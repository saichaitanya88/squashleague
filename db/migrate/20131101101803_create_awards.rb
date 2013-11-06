class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :status
      t.string :award_name
      t.string :award_description

      t.timestamps
    end
  end
end
