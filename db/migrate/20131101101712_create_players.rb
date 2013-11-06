class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :status
      t.string :first_name
      t.string :last_name
      t.string :bio
      t.integer :primary_image_id
      t.integer :user_id

      t.timestamps
    end
  end
end
