class QuizController < ApplicationController

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
    @classgroup = params[:classgroup]

    @button_text = "Create Quiz"

    p "##########"
    p @classgroup

  end

  def create

    #Create a New Quiz
    @quiz = Quiz.new

    #Get the Parameters passed from form
    @quizparam = params["new_quiz"]

    #Set the Name of the Quiz
    @quiz.quiz_name = @quizparam["quiz_name"]

    #Get the Classgroup for the Quiz and Assign it
    @classgroup = Classgroup.find(@quizparam["classgroup"])
    @quiz.classgroup = @classgroup


    #Create the Questions and Associations
    @question_one = Quizquestion.new
    @question_one.question_text = @quizparam["question_one_text"]
    @question_one.question_answer = @quizparam["question_one_answer"]

    @question_two = Quizquestion.new
    @question_two.question_text = @quizparam["question_two_text"]
    @question_two.question_answer = @quizparam["question_two_answer"]

    @question_three = Quizquestion.new
    @question_three.question_text = @quizparam["question_three_text"]
    @question_three.question_answer = @quizparam["question_three_answer"]

    @question_four = Quizquestion.new
    @question_four.question_text = @quizparam["question_four_text"]
    @question_four.question_answer = @quizparam["question_four_answer"]

    @question_five = Quizquestion.new
    @question_five.question_text = @quizparam["question_five_text"]
    @question_five.question_answer = @quizparam["question_five_answer"]

    @quiz.quizquestions << @question_one
    @quiz.quizquestions << @question_two
    @quiz.quizquestions << @question_three
    @quiz.quizquestions << @question_four
    @quiz.quizquestions << @question_five

    if @quiz.save
      redirect_to classgroup_path(@classgroup)
    else
      flash[:error] = "Error - Please make sure every field is filled before submitting. (To get your old data back, please hit the back button on your browser)"
      redirect_to new_quiz_url
    end
  end

  def destroy
    @quiz.destroy
    @classgroup = param[:classgroup]
    redirect_to classgroup_path(@classgroup)

  end

  private
  def quiz_params
    params.require(:new_quiz)
  end

end
