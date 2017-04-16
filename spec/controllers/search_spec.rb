require 'rails_helper'

describe SearchController do
  describe 'GET #index' do
    let(:location) { 'Questions' }
    let(:query) { 'query' }

    before { get :index, params: {query: query, location: location} }
    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'response with succsess status' do
      expect(response).to have_http_status :success
    end

    it 'assigns @query' do
      expect(assigns(:query)).to eq query
    end

    it 'assigns @location' do
      expect(assigns(:location)).to eq location
    end

    it 'calls Search with assigned params' do
      expect(Search).to receive(:find).with(query, location)
      get :index, params: {query: query, location: location}
    end
  end
end
