class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.integer :player_id
      t.integer :password_id

      t.timestamps
    end
  end
end
