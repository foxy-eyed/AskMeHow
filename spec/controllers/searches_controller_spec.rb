require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    before { get :show, params: { search: { query: '123'} } }

    it 'assigns new Search to @search' do
      expect(assigns(:search)).to be_a(Search)
    end

    it 'set params to @search' do
      expect(assigns(:search).query).to eq('123')
    end

    it 'renders the show view' do
      expect(response).to render_template :show
    end
  end
end
