class CommentsController < ApplicationController
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
      @comment_notice = "There was an error posting your comment"
      respond_to do |format|
        format.html { redirect_to @user_story.project }
        format.js { render "comment_error.js" }
      end
    end
  end
end
