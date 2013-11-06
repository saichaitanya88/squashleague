# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Role.create(:level => "limited") #out dated users
Role.create(:level => "standard") #most users are this when created
Role.create(:level => "admin") #admins only

user = User.new
user.name = "Administrator"
user.email = "saichaitanya88@gmail.com"
user.password = "admintest2013!"
user.password_confirmation = "admintest2013!"
user.role = "admin"
user.save

# sends confirmation email to administrator
# UserMailer.registration_confirmation(user).deliver



Player.create(:status => "active", :first_name=> "player", :last_name => "1", :bio => "player 1 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "2", :bio => "player 2 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "3", :bio => "player 3 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "4", :bio => "player 4 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "5", :bio => "player 5 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "6", :bio => "player 6 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "7", :bio => "player 7 bio")
Player.create(:status => "active", :first_name=> "player", :last_name => "8", :bio => "player 8 bio")

Division.create(:status => "active", :division_level => "A")


(0..8).each do |i|

user = User.new
user.name = "User " + i.to_s
user.email = "saichaitanya88+" + i.to_s + "@gmail.com"
user.password = "1234512345"
user.password_confirmation = "1234512345"
user.role = "standard"
user.save

end
