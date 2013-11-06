class AddNotNullRuleToPlayerFirstAndLastName < ActiveRecord::Migration
  def change
	 # change_column :players, :first_name, :column_type, :null => false
	  change_column :players, :first_name, :string, :null => false
	   change_column :players, :last_name, :string, :null => false
  end
end
