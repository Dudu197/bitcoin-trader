class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :number
      t.float :balance
      t.float :money

      t.timestamps
    end
  end
end
