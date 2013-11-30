class CreatePosts < ActiveRecord::Migration
  def change
    add_column :posts, :match_id, :integer
  end
end
