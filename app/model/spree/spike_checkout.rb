class Spree::SpikeCheckout < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :order
  belongs_to :user

  scope :with_payment_profile, -> { where('user_id IS NOT NULL') }
end
