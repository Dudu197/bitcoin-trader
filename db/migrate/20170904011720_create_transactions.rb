class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :value
      t.integer :type

      t.timestamps
    end
  end
end
