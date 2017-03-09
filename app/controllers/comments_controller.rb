class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]
  after_action :create_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:notice] = 'Comment succsesfully added'
    else
      flash.now[:alert] = 'Error'
    end
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

  def set_commentable
    commentable_type = params[:comment][:commentable_type].classify.constantize
    commentable_id =  params[:comment][:commentable_id]
    @commentable = commentable_type.find(commentable_id)
  end
end
