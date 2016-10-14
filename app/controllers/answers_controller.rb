class AnswersController < ApplicationController
  before_action :get_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def get_question
    @question = Question.find(params[:question_id])
  end
end
