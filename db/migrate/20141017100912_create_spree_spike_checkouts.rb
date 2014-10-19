class CreateSpreeSpikeCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_spike_checkouts do |t|
      t.string :token
      t.string :transaction_id
      t.datetime :created_at
      t.string :state
      t.text :spike_param
      t.references :payment_method, index: true
      t.references :order, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
