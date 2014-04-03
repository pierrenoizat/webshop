# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

rate = Rate.create(:name => 'EUR', :valeur => 800)
rate.save

user = User.create(:name => "Pierre", :password => "password", :password_confirmation => "password")
user.save