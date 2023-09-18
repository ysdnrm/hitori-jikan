# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


admin_password = ENV['ADMIN_PASSWORD']

# 管理者情報
User.create!(name:  "kagoshima",
             email: "kagoshima@mail.com",
             password: admin_password,
             password_confirmation: admin_password,
             admin: true)

