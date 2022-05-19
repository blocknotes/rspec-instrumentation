# frozen_string_literal: true

module RSpecInstrumentation
  class Sentry
    RSPEC_EVENTS = %i[example_finished example_started start stop].freeze

    def initialize(config)
      config.reporter.register_listener(self, *RSPEC_EVENTS)
    end

    def example_finished(notification)
      example = notification.example
      case example.execution_result.status
      when :passed
        @transaction.set_status('ok')
      when :failed
        @transaction.set_data('failure', example.execution_result.exception.to_s)
        @transaction.set_status('internal_error')
      end
      @transaction.finish
    end

    def example_started(notification)
      example = notification.example
      location = example.metadata[:location].delete_prefix('./')
      @transaction = ::Sentry.start_transaction(name: example.full_description, op: 'test-run', description: location)
      @transaction.set_tag('type', example.metadata[:type])
      @transaction.set_data('location', example.metadata[:location])
    end

    def start(_notification)
      @start_timestamp = Time.now.to_f
    end

    def stop(notification)
      info = "#{notification.examples.count} examples, #{notification.failed_examples.count} failures"
      attrs = { name: 'Suite run', op: 'suite-run', start_timestamp: @start_timestamp, description: info }
      transaction = ::Sentry.start_transaction(attrs)
      transaction.set_data('examples_count', notification.examples.count)
      transaction.set_data('failed_examples_count', notification.failed_examples.count)
      transaction.finish
    end
  end
end
