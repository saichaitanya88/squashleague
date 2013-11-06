class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :status
      t.string :image_type
      t.string :image_url
      t.string :image_alt
      t.string :image_description

      t.timestamps
    end
  end
end
