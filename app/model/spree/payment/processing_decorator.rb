module Spree
  Payment::Processing.class_eval do

    def cancel!
      spike_checkout = Spree::SpikeCheckout.find_by_order_id(self.order_id)
      if payment_method.respond_to?(:cancel)
        response = payment_method.cancel(spike_checkout.transaction_id)
        spike_checkout.state = response.params['state']
        spike_checkout.save!
        self.class.create!(
             :order => order,
             :source => self,
             :payment_method => payment_method,
             :amount => response.params['amount'].to_i * -1,
             :response_code => response.params['transaction_id'],
             :state => 'completed'
        )
        self.save
      else
        credit!(credit_allowed.abs)
      end
    end

    private

    def handle_response(response, success_state, failure_state)
      record_response(response)

      if response.success?
        unless response.authorization.nil?
          self.response_code = response.authorization
          self.avs_response = response.avs_result['code']

          if response.cvv_result
            self.cvv_response_code = response.cvv_result['code']
            self.cvv_response_message = response.cvv_result['message']
          end
        end
        spike_checkout = Spree::SpikeCheckout.find_by_order_id(self.order_id)
        spike_checkout.transaction_id = response.params['transid']
        spike_checkout.state = response.params['state']
        spike_checkout.save!
        self.send("#{success_state}!")
      else
        self.send(failure_state)
        gateway_error(response)
      end
    end
  end
end
