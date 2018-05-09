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

@paul.save
@admin.save

# Creating Students to Populate the System

@aaron = Student.new(first_name: "Aaron", last_name: "Meaney", user_id: 2)
@student = User.new(id: 1, email: "aaron@mail.com", password: "123456", is_admin: false, student: @aaron)
@aaron.save
@student.save


# Creating Classes to Populate the System

@itp = Classgroup.new(id: 0, class_name: "Intro to Programming", course_name: "BSHC",
                      class_description: "Learn to Program using Java", enrollment_key: 9109, image_id: 1, lecturer_id: 1)
@itp.students << @aaron
@itp.save

@iwd = Classgroup.new(id: 1, class_name: "Intro to Web Design", course_name: "BSHC",
                      class_description: "Learn to make Basic Websites using HTML, CSS and JS", enrollment_key: 9101, image_id: 1, lecturer_id: 1)
@iwd.save

@itc = Classgroup.new(id: 2, class_name: "Introduction to Computers", course_name: "BSHC",
                      class_description: "Learning All about how to use a Computer", enrollment_key: 9102, image_id: 1, lecturer_id: 1)
@itc.save

@iot = Classgroup.new(id: 3, class_name: "Internet of Things", course_name: "BSHC",
                      class_description: "Solving the worlds problems 1 MQTT message at a time", enrollment_key: 9103, image_id: 1, lecturer_id: 1)
@iot.save

@cad = Classgroup.new(id: 4, class_name: "Cloud Application Development", course_name: "BSHC",
                      class_description: "Just know that Rails is never sorry", enrollment_key: 9104, image_id: 1, lecturer_id: 1)
@cad.save

# Creating a Example Session for the System

@ses = Classsession.new(id: 0, topic: "The Basics of Programming", classgroup_id: 0, session_key: 0000)
@ses.save


