require 'rails_helper'

shared_examples 'voted' do
  # может есть способ получше чтобы получать символ модели
  model = controller_class.controller_path.singularize
  let(:votable) { create(model.to_sym) }

  describe 'POST #vote_up' do
    sign_in_user
    let(:vote_up) { post :vote_up, votable_id: votable.id, votable_type: votable.class.name, format: :js }

    context 'if user is not author of votable' do
      it "create vote with value 1" do
        vote_up
        expect(votable.votes.first.value).to eq 1
      end

      it "render json with votable id and rating" do
        vote_up
        expect(response.body).to eq ({ id: votable.id, rating: votable.rating }).to_json
      end
    end

    context 'if user is author of votable' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "doesn't create vote" do
        vote_up
        expect(votable.votes.count).to eq 0
      end

      it "render nothing with status 422" do
        vote_up
        expect(response.body).to eq ''
        expect(response.status).to eq 422
      end
    end

  end

  describe 'POST #vote_down' do
    sign_in_user
    let(:vote_down) { post :vote_down, votable_id: votable.id, votable_type: votable.class.name, format: :js }

    context 'if user is not author of votable' do
      it "create vote with value -1" do
        vote_down
        expect(votable.votes.first.value).to eq -1
      end

      it "render json with votable id and rating" do
        vote_down
        expect(response.body).to eq ({ id: votable.id, rating: votable.rating }).to_json
      end
    end

    context 'if user is author of votable' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "doesn't create vote" do
        vote_down
        expect(votable.votes.count).to eq 0
      end

      it "render nothing with status 422" do
        vote_down
        expect(response.body).to eq ''
        expect(response.status).to eq 422
      end
    end
  end

  describe 'POST #vote_cancel' do
    sign_in_user
    let(:vote_cancel) { post :vote_cancel, votable_id: votable.id, votable_type: votable.class.name, format: :js }
    let!(:vote) { create(:vote, :up, votable: votable, user: @user) }

    it "destroy vote" do
      vote_cancel
      expect(votable.votes.count).to eq 0
    end

    it "render json with votable id and rating" do
      vote_cancel
      expect(response.body).to eq ({ id: votable.id, rating: votable.rating }).to_json
    end
  end
end
