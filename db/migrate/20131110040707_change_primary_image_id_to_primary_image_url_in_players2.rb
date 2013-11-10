class ChangePrimaryImageIdToPrimaryImageUrlInPlayers2 < ActiveRecord::Migration
  def change
		remove_column :players, :primary_image_id, :integer
  end
end
