class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_comment, only: [:destroy]
  before_action :get_commentable, only: [:new, :create]
  before_action :check_authority, only: [:destroy]

  respond_to :json
  respond_to :js, only: [:new]

  def new
    respond_with(@comment = @commentable.comments.new)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end

  def get_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end

    head :unprocessable_entity unless @commentable
  end

  def check_authority
    head :forbidden unless current_user.author_of?(@comment)
  end
end
