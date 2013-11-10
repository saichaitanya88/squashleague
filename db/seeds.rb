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
UserMailer.registration_confirmation(user, "admintest2013!").deliver
