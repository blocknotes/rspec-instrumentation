# frozen_string_literal: true

module RSpecInstrumentation
  class NewRelic
    RSPEC_EVENTS = %i[example_finished example_started start stop].freeze

    def initialize(config)
      config.reporter.register_listener(self, *RSPEC_EVENTS)
    end

    def example_finished(notification)
      result = notification.example.execution_result
      if result.status == :failed
        details = failed_example_details(notification.example)
        ::NewRelic::Agent.notice_error(result.exception.to_s, custom_params: details)
      end
      @transaction.finish
    end

    def example_started(notification)
      name = notification.example.id.delete_prefix('./')
      @transaction = ::NewRelic::Agent::Tracer.start_transaction_or_segment(partial_name: name, category: :task)
    end

    def failed_example_details(example)
      {
        location: example.metadata[:location],
        type: example.metadata[:type]
      }
    end

    def start(_notification)
      # puts '> start'
    end

    def stop(_notification)
      ::NewRelic::Agent.shutdown
    end

    class << self
      def setup
        require 'newrelic_rpm'
        require 'new_relic/agent/tracer'

        ::NewRelic::Agent.manual_start
      end
    end
  end
end
