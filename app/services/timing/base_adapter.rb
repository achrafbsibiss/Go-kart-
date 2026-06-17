module Timing
  # Interface a concrete timing-hardware integration implements. A real
  # adapter connects to the venue's timing system (SMS-Timing, MyLaps X2,
  # AMB/TranX, …) and yields Timing::LapEvent objects as karts cross the line.
  #
  # Implement #each_event for a streaming feed, or #poll for a request/response
  # API, then register the class in config/initializers/timing.rb.
  class BaseAdapter
    def initialize(race:, config: {})
      @race = race
      @config = config
    end

    attr_reader :race, :config

    # Yield Timing::LapEvent objects. Default implementation polls in a loop.
    def each_event
      loop do
        poll.each { |event| yield event }
        sleep(config.fetch(:poll_interval, 1))
      end
    end

    # Return an array of LapEvents for the current poll. Override for HTTP feeds.
    def poll
      raise NotImplementedError, "#{self.class} must implement #poll or #each_event"
    end
  end
end
