class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :status
      t.integer :player1_id
      t.integer :player2_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
