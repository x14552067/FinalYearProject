class ClassgroupsController < ApplicationController

  def index

    if current_user.lecturer.nil?

      if current_user.student.classgroups.nil?
        @classes = nil
      else
        @classes = current_user.student.classgroups
      end
        render 'student_view'
    else
      @classes = current_user.lecturer.classgroups
      render 'lecturer_view'
    end

  end

  def show
    @classgroup = Classgroup.find(params[:id])
    @student_count = @classgroup.students.to_ary.count

    if current_user.lecturer.nil?
      @sessions = @classgroup.classsessions
      render 'student_show'
    else
      @students = @classgroup.students
      @sessions = @classgroup.classsessions
      @quizzes = @classgroup.quizzes
      @poll_count = 0
      @quiz_count = 0;

      @classgroup.classsessions.each do |ses|
        @poll_count = @poll_count + ses.understanding_polls.count
        @quiz_count = @quiz_count + ses.quizzes.count
      end

      #Multiply by 5 because each quiz has 5 questions!
      @quiz_question_count = (@quiz_count*5)

      render 'lecturer_show'
    end


  end

  def new
    @classgroup = Classgroup.new
    @button_text = "Create Class"
  end

  def edit
    @classgroup = Classgroup.find(params[:id])
    @button_text = "Save Changes"

  end

  def create
    #Check if a Classgroup already exists, if they do, make the new ID equal to the next available ID.
    # We do this because we need to generate the Classgroup Enrollment Key based on the ID (Unique ID) of the Classgroup, which is typically
    # Only generated when the Record is saved.
    if (Classgroup.any?)
      @id = Classgroup.maximum(:id).next
    else
      @id = 0
    end

    #Manually Set all the Fields because some of the fields are set behind the scenes
    @classgroup = Classgroup.new(classgroup_params)
    @classgroup.class_name = classgroup_params[:class_name]
    @classgroup.id = @id
    @enrollment_key = generate_key(@id)
    @classgroup.enrollment_key = @enrollment_key
    @classgroup.lecturer = current_user.lecturer

    #Get the Image passed in
    @image = classgroup_params[:image_id]

    #Determine the Image based on the Param Passed from the form
    if @image == "Computer"
      @classgroup.image_id = 1
    elsif @image == "Web"
      @classgroup.image_id = 2
    elsif @image == "Business"
      @classgroup.image_id = 3
    elsif @image == "Statistics"
      @classgroup.image_id = 4
    elsif @image == "Generic"
      @classgroup.image_id = 5
    elsif @image == "Comical"
      @classgroup.image_id = 6
    else
      @classgroup.image_id = 1
    end

    if @classgroup.save
      redirect_to @classgroup
    else
      render 'new'
    end
  end

  def update

    @classgroup = Classgroup.find(params[:id])

    if @classgroup.update_attributes(classgroup_params)
      redirect_to @classgroup
    else
      format.html {render :edit}
    end
  end

  def destroy

    @classgroup = Classgroup.find(params[:id])
    @classgroup.destroy
    redirect_to classgroups_path

  end

  private
  def classgroup_params
    params.require(:classgroup).permit(:class_name, :course_name, :class_description, :classgroup, :image_id)
  end

end
