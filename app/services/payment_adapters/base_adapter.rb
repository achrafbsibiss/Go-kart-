module PaymentAdapters
  # Interface every payment provider adapter implements.
  class BaseAdapter
    def provider_name
      self.class.name.demodulize.sub(/Adapter\z/, "").underscore
    end

    # Begin checkout for a pending Payment. Must return a PaymentService::Result.
    def start_checkout(_payment)
      raise NotImplementedError, "#{self.class} must implement #start_checkout"
    end

    # Process an incoming provider webhook. Return the updated Payment or nil.
    def handle_webhook(_params, _headers)
      raise NotImplementedError, "#{self.class} must implement #handle_webhook"
    end
  end
end
