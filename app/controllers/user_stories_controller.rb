class UserStoriesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    @user_story = UserStory.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user_story = UserStory.find(params[:id])
    @comments = @user_story.comments
    @comment = @user_story.comments.new
    @project = @user_story.project
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("position"))
    @users = UserDecorator.decorate_collection(@project.users)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @user_story = @project.user_stories.new.decorate
    @team = @project.team

    @user_story.update_attributes(params[:user_story])
    track_activity(@user_story)
    @activity = find_activity
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

    render "edit", :formats => [:js]
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
    @team = @project.team
    yield(@story)
    track_activity(@story, information=@story.state, action="change_state")
    @activity = find_activity
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
    @team = @project.team
    track_activity(@story, information=@user.id)
    @activity = find_activity
    UserStoryMailer.assignment_mailer(@user, @story)

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

private

  def find_activity
    Activity.where(project_id: @project.id).order("created_at DESC").first
  end

end
