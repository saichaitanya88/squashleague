class CreateSeasonsToDivisions < ActiveRecord::Migration
  def change
    create_table :seasons_to_divisions do |t|
      t.integer :division_id
      t.integer :season_id

      t.timestamps
    end
  end
end
