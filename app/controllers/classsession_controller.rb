class ClasssessionController < ApplicationController

  def show
    @messages = Chatmessage.all
  end

end
