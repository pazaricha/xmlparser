class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :card_id
      t.integer :personal_id
      t.integer :card_expiration
      t.string :cgresponse_text
      t.decimal :amount, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
