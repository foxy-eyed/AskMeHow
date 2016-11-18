class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_answer, only: [:edit, :update, :destroy, :accept]
  before_action :get_question, only: [:create]
  before_action :check_authority, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def accept
    return redirect_to @answer.question, alert: 'Permission denied!' unless current_user.author_of?(@answer.question)
    @answer.accept
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

  def check_authority
    redirect_to @answer.question, alert: 'Permission denied!' unless current_user.author_of?(@answer)
  end
end
