class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_subscription, only: :destroy
  before_action :get_question, only: :create

  respond_to :json

  authorize_resource

  def create
    respond_with(@subscription = current_user.subscriptions.create(question: @question))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def get_subscription
    @subscription = Subscription.find(params[:id])
  end

  def get_question
    @question = Question.find(params[:question_id])
  end
end