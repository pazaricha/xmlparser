class AddResponseUrlToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :response_url, :string
  end
end
