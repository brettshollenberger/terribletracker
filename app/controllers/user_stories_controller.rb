class UserStoriesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @user_story = UserStory.new

    respond_to do |format|
      format.html
      format.js
    end
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
    @comments = CommentDecorator.decorate_collection(@user_story.comments.order("created_at DESC"))
    @comment = @user_story.comments.new

    render "edit.js"
  end

  def update
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.find(params[:id])
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("position"))
    @users = UserDecorator.decorate_collection(@project.users)
    @team = @project.team

    @user_story.update_attributes(params[:user_story])
    respond_to do |format|
      format.js
    end
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
    @story = @story.decorate
    @project = @story.project
    yield(@story)

    respond_to do |format|
      format.html { redirect_to @project }
      format.js { render "update_story" }
    end
  end

  def assign
    @user = User.find(params[:id])
    @story = UserStory.find(params[:user_story_id])
    @story = @story.decorate
    @story.user = @user
    @story.save
    @project = @story.project
    flash[:notice] = "#{@user.decorate.full_name} assigned"
    respond_to do |format|
      format.html { redirect_to @story.project }
      format.js   { render "update_story" }
    end
  end

  def sort
    params[:user_story].each_with_index do |id, index|
      UserStory.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

end
