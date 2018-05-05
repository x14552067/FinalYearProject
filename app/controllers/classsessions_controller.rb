class ClasssessionsController < ApplicationController

  def show
    @messages = Chatmessage.all
  end

end
