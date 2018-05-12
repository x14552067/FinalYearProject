# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating Lecturers to Populate the System

@admin = User.new(id: 9999, email: "paulreid@mail.com", password: "123456", is_admin: true)
@paul = Lecturer.new(first_name: "Paul", last_name: "Reid", institute: "NCI", user_id: 9999)
@admin.lecturer = @paul

@paul.save
@admin.save

# Creating Students to Populate the System

@student = User.new(id: 9090, email: "paulreid96@gmail.com", password: "123456", is_admin: false)
@aaron = Student.new(first_name: "Aaron", last_name: "Meaney", user_id: 9090)
@student.student = @aaron

@aaron.save
@student.save


# Creating Classes to Populate the System

@itp = Classgroup.new(id: 0, class_name: "Intro to Programming", course_name: "BSHC",
                      class_description: "Learn to Program using Java", enrollment_key: 9109, image_id: 1, lecturer_id: 1)
@itp.students << @aaron
@itp.save

@iwd = Classgroup.new(id: 1, class_name: "Intro to Web Design", course_name: "BSHC",
                      class_description: "Learn to make Basic Websites using HTML, CSS and JS", enrollment_key: 9101, image_id: 2, lecturer_id: 1)
@iwd.save

@itc = Classgroup.new(id: 2, class_name: "Introduction to Computers", course_name: "BSHC",
                      class_description: "Learning All about how to use a Computer", enrollment_key: 9102, image_id: 3, lecturer_id: 1)
@itc.save

@iot = Classgroup.new(id: 3, class_name: "Internet of Things", course_name: "BSHC",
                      class_description: "Solving the worlds problems 1 MQTT message at a time", enrollment_key: 9103, image_id: 4, lecturer_id: 1)
@iot.save

@cad = Classgroup.new(id: 4, class_name: "Cloud Application Development", course_name: "BSHC",
                      class_description: "Just know that Rails is never sorry", enrollment_key: 9104, image_id: 5, lecturer_id: 1)
@cad.save

# Creating a Example Session for the System

@ses = Classsession.new(id: 0, topic: "The Basics of Programming", classgroup_id: 0, session_key: 0000)
@ses.start_time = "2018-05-12 11:32:41"
@ses.end_time = "2018-05-12 12:32:41"
@ses.save


# Create an Example Quiz for the System

@quiz = Quiz.new
@quiz.classgroup = @itp

@question_one = Quizquestion.new
@question_one.question_text = "What is 1+1?"
@question_one.question_answer = "2"

@question_two = Quizquestion.new
@question_two.question_text = "What is 2+1?"
@question_two.question_answer = "3"

@question_three = Quizquestion.new
@question_three.question_text = "What is 3+1?"
@question_three.question_answer = "4"

@question_four = Quizquestion.new
@question_four.question_text = "What is 4+1?"
@question_four.question_answer = "5"

@question_five = Quizquestion.new
@question_five.question_text = "What is 5+1?"
@question_five.question_answer = "6"

@quiz.save

@quiz.quizquestions << @question_one
@quiz.quizquestions << @question_one
@quiz.quizquestions << @question_one
@quiz.quizquestions << @question_one
@quiz.quizquestions << @question_one


@quiz.save

@question_one.save
@question_two.save
@question_three.save
@question_four.save
@question_five.save

