class UserStoriesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @user_story = UserStory.new
  end

  def create
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.new.decorate

    @user_story.update_attributes(params[:user_story])

    respond_to do |format|
      format.html { redirect_to @project }
      format.js
    end
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

  def destroy
    @story = UserStory.find(params[:id])
    @project = @story.project
    @story.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.js
    end
  end

  def unstarted
    change_state { |story| story.unstart }
  end

  def started
    change_state { |story| story.start }
  end

  def review
    change_state { |story| story.mark_for_review }
  end

  def finished
    change_state { |story| story.finish }
  end

  def change_state(&block)
    @story = UserStory.find(params[:id])
    @project = @story.project
    yield(@story)
    redirect_to @project
  end

  def assign
    @user = User.find(params[:id])
    @user_story = UserStory.find(params[:user_story_id])
    @user_story.user = @user
    @user_story.save
    flash[:notice] = "#{@user.decorate.full_name} assigned"
    redirect_to @user_story.project
  end

end
