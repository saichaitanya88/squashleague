class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :division_level
      t.string :status

      t.timestamps
    end
  end
end
