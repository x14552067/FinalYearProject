class StaticPagesController < ApplicationController
  layout "landing", only: [:index]

  skip_before_action :authenticate_user!

  def index

  end

end
