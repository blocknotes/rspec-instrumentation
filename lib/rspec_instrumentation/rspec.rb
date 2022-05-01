# frozen_string_literal: true

module RSpecInstrumentation
  module RSpec
    module_function

    def setup(config, service:)
      case service
      when :new_relic then NewRelic.new(config)
      else warn("Unknown service: #{service}")
      end
    end
  end
end
