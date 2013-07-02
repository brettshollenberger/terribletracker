class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def new_user_story_comment
    @user_story = UserStory.find(params[:comment][:user_story])
    @user = current_user
    @comment = @user_story.comments.new(body: params[:comment][:body], user: @user).decorate

    if @comment.save
      respond_to do |format|
        format.html
        format.js
      end
    else
      @comment_notice = "You've already said that here."
      @comment_notice = "" if @comment.body.length == 0
      respond_to do |format|
        format.html { redirect_to @user_story.project }
        format.js { render "comment_error.js" }
      end
    end
  end
end
