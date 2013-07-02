class ActivitiesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @activities = Activity.order('created_at desc')
  end

end
