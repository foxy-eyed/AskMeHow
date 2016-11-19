class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_answer, only: [:edit, :update, :destroy, :accept]
  before_action :get_question, only: [:create]
  before_action :check_answer_authority, only: [:edit, :update, :destroy]
  before_action :check_question_authority, only: [:accept]

  respond_to :js, only: [:edit, :update, :accept]
  respond_to :json, only: [:create, :destroy]

  def create
    respond_with(@question.answers.create(answer_params.merge(user: current_user)))
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def accept
    @answer.accept
    respond_with(@answer)
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

  def check_answer_authority
    head :forbidden unless current_user.author_of?(@answer)
  end

  def check_question_authority
    head :forbidden unless current_user.author_of?(@answer.question)
  end
end
