# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating Lecturers to Populate the System

@paul = Lecturer.new(first_name: "Paul", last_name: "Reid", institute: "NCI", user_id: 1)

@admin = User.new(id: 0, email: "paulreid@mail.com", password: "123456", is_admin: true, lecturer: @paul)

# Creating Students to Populate the System

@aaron = Student.new(first_name: "Aaron", last_name: "Meaney", user_id: 2)
@student = User.new(id: 1, email: "aaron@mail.com", password: "123456", is_admin: false, student: @aaron)


# Creating Classes to Populate the System

@itp = Classgroup.new(id: 0, class_name: "Intro to Programming", course_name: "BSHC",
                      class_description: "Learn to Program using Java", unique_id: 9109, image_id: 1, lecturer_id: 1)

