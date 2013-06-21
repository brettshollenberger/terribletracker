class UserStoriesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @user_story = UserStory.new
  end

  def create
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.new

    if @user_story.update_attributes(params[:user_story])
      flash[:notice] = "User story added"
    else
      flash[:error] = "There was an error adding your user story"
    end
    redirect_to project_path(@project)
  end

  def edit
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.find(params[:id])

    if @user_story.update_attributes(params[:user_story])
      flash[:notice] = "Story updated!"
    else
      flash[:notice] = "There was an error updating your story"
    end
    redirect_to @project
  end

end
