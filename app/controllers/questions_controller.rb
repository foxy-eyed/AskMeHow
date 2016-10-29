class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]
  before_action :check_authority, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def get_question
    @question = Question.find(params[:id])
  end

  def check_authority
    redirect_to questions_path, alert: 'Permission denied!' unless current_user.author_of?(@question)
  end
end
