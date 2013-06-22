class UserStoriesController < ApplicationController
  def new
    @projects, @invitations = find_projects
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
    @projects, @invitations = find_projects
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

    if @story.delete
      flash[:notice] = "Story Deleted"
    else
      flash[:notice] = "There was an error deleting your story"
    end
    redirect_to @project
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

  def find_projects
    active_projects_list = []
    invitations = []
    current_user.memberships.each do |membership|
      active_projects_list.push(membership.project) if membership.state == "active"
      invitations.push(membership) if membership.state == "pending"
    end
    return active_projects_list, MembershipDecorator.decorate_collection(invitations)
  end

end
