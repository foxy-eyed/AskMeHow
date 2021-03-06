class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :check_subscription, only: :show
  before_action :store_user_id, only: :show

  respond_to :html
  respond_to :js, only: [:edit, :update]

  authorize_resource

  def index
    respond_with(@questions = Question.includes(:user))
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def edit
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def get_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def store_user_id
    gon.push({ current_user_id: current_user.id }) if user_signed_in?
  end

  def check_subscription
    @subscription = Subscription.find_or_initialize_by(user_id: current_user, question: @question) if can?(:create, Subscription)
  end
end
