class ClassistantMailer < ApplicationMailer
  default from: "classistant@protonmail.com"

  def support_email
    @student = params[:student]
    @classgroup = params[:classgroup]
    @lecturer = @classgroup.lecturer

    @user = @student.user

    mail(to: @user.email,
         subject: 'Classistant | Notice from Lecturer: ')
  end

  def attendance_email
    @student = params[:student]
    @classgroup = params[:classgroup]
    @lecturer = @classgroup.lecturer
    @user = @student.user

    mail(to: @user.email,
         subject: 'Classistant | Notice from Lecturer: ')
  end

  def help_email
    @student = params[:student]
    @session = params[:classsession]
    @user = @student.user

    mail(to: @user.email,
         subject: 'Classistant | Addiontal Resources to look over after the last Session: ')
  end

end