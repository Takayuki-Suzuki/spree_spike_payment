module Spree
  Payment.class_eval do
    def build_source
      return unless new_record?
      if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
        self.source = payment_method.payment_source_class.new(source_attributes)
        self.source.payment_method_id = payment_method.id
        self.source.user_id = self.order.user_id if self.order
        self.source.order_id = self.order.id if self.order
      end
    end
  end
end
