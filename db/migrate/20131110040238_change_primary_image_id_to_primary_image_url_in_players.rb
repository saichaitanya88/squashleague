class ChangePrimaryImageIdToPrimaryImageUrlInPlayers < ActiveRecord::Migration

	def change
		remove_column :players, :player_image_id, :integer
		add_column :players, :player_image_url, :string
	end

end
