require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:questions) { create_list(:question, 2, title: 'search sphinx') }
  describe 'GET #search' do
    context 'with valid parameters' do
      context 'in model' do
        let(:search_by_model) { get :search, query: 'sphinx', search_by: 'questions' }

        it 'search with required model' do
          expect(Question).to receive(:search).with('sphinx')
          search_by_model
        end

        it 'assigns results of search to @search_results' do
          search_by_model
          expect(assigns(:search_results)).to be_instance_of(ThinkingSphinx::Search)
        end

        it 'redirect to search view' do
          search_by_model
          expect(response).to render_template :search
        end
      end

      context 'everywhere' do
        let(:search_everywhere) { get :search, query: 'sphinx', search_by: 'everywhere' }

        it 'search with required model' do
          expect(ThinkingSphinx).to receive(:search).with('sphinx')
          search_everywhere
        end

        it 'assigns results of search to @search_results' do
          search_everywhere
          expect(assigns(:search_results)).to be_instance_of(ThinkingSphinx::Search)
        end

        it 'redirect to search view' do
          search_everywhere
          expect(response).to render_template :search
        end
      end
    end

    context 'with invalid parameters' do
      before { get :search, query: 'sphinx', search_by: 'invalid' }

      it 'redirect to root path' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
