# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Client.destroy_all if Rails.env.development?

admin = Client.create( name: "admin", password: "password", email: "admin@gorgu.net", active: true)
admin.add_role :gram_admin
admin.add_role :admin
admin.save

client = Client.create( name: "client", password: "password", email: "client@gorgu.net", active: true)
client.add_role :read
client.save
