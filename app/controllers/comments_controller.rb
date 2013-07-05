class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user_story = UserStory.find(params[:comment][:user_story])
    @comment = current_user.comments.new(body: params[:comment][:body], commentable: @user_story).decorate

    if @comment.save
      render "create.js"
    else
      @comment_notice = "You've already said that here."
      @comment_notice = "" if @comment.body.length == 0
      render "comment_error.js"
    end
  end
end
