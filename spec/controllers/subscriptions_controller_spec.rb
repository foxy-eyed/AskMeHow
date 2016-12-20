require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  sign_in_user

  describe 'POST #create' do
    context 'if user was not subscribed before' do
      it 'creates new subscription in db' do
        expect { process :create, method: :post, params: { question_id: question }, format: :js }
            .to change(@user.subscriptions.where(question: question), :count).by(1)
      end
    end

    context 'if user already subscribed' do
      let!(:subscription) { create(:subscription, user: @user, question: question) }

      it 'does not create new record in db' do
        expect { process :create, method: :post, params: { question_id: question }, format: :js }
            .to_not change(Subscription, :count)
      end
    end

    it 'renders create view' do
      process :create, method: :post, params: { question_id: question }, format: :js
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    context 'delete by subscriber' do
      let!(:subscription) { create(:subscription, user: @user) }

      it 'deletes subscription from db' do
        expect { process :destroy, method: :delete, params: { id: subscription.id }, format: :js }
            .to change(Subscription, :count).by(-1)
      end
    end

    context 'delete by someone else' do
      let!(:subscription) { create(:subscription) }

      it 'does not delete subscription from db' do
        expect { process :destroy, method: :delete, params: { id: subscription.id }, format: :js }
            .to_not change(Subscription, :count)
      end

      it 'responds with status 403 (forbidden)' do
        process :destroy, method: :delete, params: { id: subscription.id }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end
end
