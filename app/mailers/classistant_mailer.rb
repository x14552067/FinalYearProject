class ClassistantMailer < ApplicationMailer
  default from: "classistant@protonmail.com"

  def support_email
    @student = params[:student]
    mail(to: @student.email,
         subject: 'Classistant | Notice from Lecturer: ')
  end
end