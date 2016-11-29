class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_answer, only: [:edit, :update, :destroy, :accept]
  before_action :get_question, only: [:create]

  respond_to :js, only: [:edit, :update, :accept]
  respond_to :json, only: [:create, :destroy]

  authorize_resource

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
end
