require('spike_pay')
module Spree
  class Gateway::Spike < Gateway
    preference :token, :string
    preference :secret_key, :string

    def build_source
      return unless new_record?
      if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
        self.source = payment_method.payment_source_class.new(source_attributes)
        self.source.payment_method_id = payment_method.id
        self.source.order_id = self.order.id if self.order
        self.source.user_id = self.order.user_id if self.order
      end
    end

    def provider_class
      ::SpikePay
    end

    def payment_source_class
      Spree::SpikeCheckout
    end

    def supports?(source)
      source.is_a? payment_source_class
    end

    def source_required?
      true
    end

    def provider
      SpikePay.new('sk_test_e8vI8FfHYlMaPDhhaSg451Yl')
    end

    def can_capture?
      true
    end

    def method_type
      'spike'
    end

    def success?
      @success
    end

    def success=(success)
      @success = success
    end

    def payment
      true
    end

    def authorization
      true
    end

    def purchase(amount, spike_checkout, options={})

      response = provider.charge.create(JSON.parse(spike_checkout['spike_param']))

      if response.paid == true
        @success = TRUE
      else
        @success = FALSE
      end
      ActiveMerchant::Billing::Response.new(
          @success,
          "Transaction successful",
          :transid => response.id,
          :amount => response.amount,
          :state => "paid",
      )
    end

    def cancel(trans_id)

      response = provider.charge.refund({id: trans_id})

      if response.refunded == true
        @success = TRUE
      else
        @success = FALSE
      end
      ActiveMerchant::Billing::Response.new(
          @success,
          "Refund successful",
          :transid => response.id,
          :amount => response.amount,
          :state => "refunded",
      )
    end
  end
end
