class ClassgroupsController < ApplicationController

  def index

    if current_user.lecturer.nil?
      @classes = current_user.student.classgroups
      render 'student_view'
    else
      @classes = current_user.lecturer.classgroups
      render 'lecturer_view'
    end

  end

  def show
    @classgroup = Classgroup.find(params[:id])
    @students = @classgroup.students

    if current_user.lecturer.nil?
      render 'student_show'
    else
      @students = @classgroup.students
      render 'lecturer_show'
    end



  end

  def new
    @classgroup = Classgroup.new

  end

  def create

    if(Classgroup.any?)
      @id = Classgroup.maximum(:id).next
    else
      @id = 1
    end

    #Manually Set all the Fields because some of the fields are set behind the scenes
    @classgroup = Classgroup.new(classgroup_params)
    @classgroup.class_name = classgroup_params[:class_name]
    @classgroup.id = @id
    @uniqueId = (@id * 1000 + rand(999))
    @classgroup.unique_id = @uniqueId
    @classgroup.image_id = 1
    @classgroup.lecturer = current_user.lecturer

    if @classgroup.save
      redirect_to @classgroup

    else
      render 'new'
    end



  end

  def enroll



  end

  private
  def classgroup_params
    params.require(:classgroup).permit(:class_name, :course_name, :class_description, :classgroup)
  end

end
