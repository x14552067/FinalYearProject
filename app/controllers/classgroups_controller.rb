class ClassgroupsController < ApplicationController

  def index

    if current_user.lecturer.nil?

      if current_user.student.classgroups.nil?
        @classes = nil
      else
        @classes = current_user.student.classgroups

      end
        p "##########"
        p @classes
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
      render 'student_show'
    else
      @students = @classgroup.students
      @sessions = @classgroup.classsessions
      @quizzes = @classgroup.quizzes
      render 'lecturer_show'

      @student = @students.find(1)
      @student = @student.user



      ClassistantMailer.with(student: @student).support_email.deliver_now

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
    @classgroup.image_id = 1
    @classgroup.lecturer = current_user.lecturer

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

  private
  def classgroup_params
    params.require(:classgroup).permit(:class_name, :course_name, :class_description, :classgroup)
  end

end
