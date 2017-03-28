class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  after_action :create_comment, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def create_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      'comments',
      comment: @comment,
    )
  end

  def load_commentable
    commentable_type = params[:comment][:commentable_type].classify.constantize
    commentable_id =  params[:comment][:commentable_id]
    @commentable = commentable_type.find(commentable_id)
  end
end
