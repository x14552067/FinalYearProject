# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@paul = Lecturer.new(first_name: "Paul", last_name: "Reid", institute: "NCI", user_id: 1)

@admin = User.new
@admin.id = 0
@admin.email = "paulreid@mail.com"
@admin.password = "123456"
@admin.is_admin = true
@admin.lecturer = @paul
@admin.save



