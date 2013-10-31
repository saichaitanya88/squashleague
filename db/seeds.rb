# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#recreate roles to avoid adding
Role.all.each do |role|
	role.destroy
end

Role.create(:level => "limited") #out dated users
Role.create(:level => "standard") #most users are this when created
Role.create(:level => "admin") #admins only
