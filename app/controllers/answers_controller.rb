class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :get_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Answer successfully added.'
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
