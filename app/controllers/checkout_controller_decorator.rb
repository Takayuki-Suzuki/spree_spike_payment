module Spree
  CheckoutController.class_eval do

    def permitted_source_attributes
      super << [:spike_param, :token, :state, :transaction_id]
    end

    def update

      payment_method_type = nil
      if params[:order][:payments_attributes].instance_of?(Array)
        payment_method_type = Spree::PaymentMethod.find(params[:order][:payments_attributes][0][:payment_method_id].to_i).type
      end

      if params[:state] == "payment" && payment_method_type == "Spree::Gateway::Spike"
        payment_method_id = params['payment_source'].keys.first

        # 課金オブジェクトの作成(products部分)
        spike_param_products = []
        @order.line_items.each do |item|
          spike_param_products << {
              id: item.variant.sku,
              title: item.variant.product.name,
              #description: item.variant.product.description ||= 'item description',
              description: 'item description',
              language: 'JA',
              price: item.price,
              currency: item.currency,
              count: item.quantity,
              stock: 0,
          }
        end

        # 課金オブジェクトの作成(全体)
        spike_param = {
            currency: @order.currency,
            amount: @order.total,
            card: params["payment_source"][payment_method_id]["token"],
            email: @order.email,
            products: spike_param_products,
        }

        params['payment_source'][payment_method_id]['spike_param'] = spike_param.to_json
      end

      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to checkout_state_path(@order.state) and return
        end

        if @order.completed?
          @current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end
  end
end
