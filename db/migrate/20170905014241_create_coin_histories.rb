class CreateCoinHistories < ActiveRecord::Migration
  def change
    create_table :coin_histories do |t|
      t.string :coin
      t.float :value
      t.datetime :date

      t.timestamps
    end
  end
end
