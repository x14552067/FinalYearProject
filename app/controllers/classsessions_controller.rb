class ClasssessionsController < ApplicationController
  layout 'session'

  def index
    
  end

  def show
    @messages = Chatmessage.all
  end

end
