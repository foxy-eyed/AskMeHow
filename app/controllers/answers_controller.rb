class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :get_answer, only: [:destroy]
  before_action :get_question, only: [:create]
  before_action :check_authority, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
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
