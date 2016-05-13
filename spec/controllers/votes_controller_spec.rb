require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  # with question as example of votable model
  describe 'POST #vote' do
    let(:question) { create(:question) }
    let(:vote_up) { post :vote, value: '1', votable_id: question.id, votable_type: 'Question', format: :js }
    let(:vote_down) { post :vote, value: '-1', votable_id: question.id, votable_type: 'Question', format: :js }

    sign_in_user

    context 'first time vote up' do
      it "create user's vote for resource" do
        expect { vote_up }.to change(question.votes, :count).by(1)
      end

      it "increase value user's vote by 1" do
        vote_up
        expect(question.votes.first.value).to eq 1
      end

      it 'respond with json' do
        vote_up
        expect(response.body).to eq question.votes.first.to_json
      end
    end

    context 'first time vote down' do
      it "create user's vote for resource" do
        expect { vote_down }.to change(question.votes, :count).by(1)
      end

      it "decrease value user's vote by 1" do
        vote_down
        expect(question.votes.first.value).to eq -1
      end

      it 'respond with json' do
        vote_down
        expect(response.body).to eq question.votes.first.to_json
      end
    end

    context 'revote up' do
      before { create(:vote, :down, votable_type: question.class, votable_id: question.id, user: @user) }

      it "doesn't create new user's vote for resource" do
        expect { vote_up }.to_not change(question.votes, :count)
      end

      it "increase value user's vote by 1" do
        vote_up
        expect(question.votes.first.value).to eq 0
      end

      it 'respond with json' do
        vote_up
        expect(response.body).to eq question.votes.first.to_json
      end
    end

    context 'revote down' do
      before { create(:vote, :up, votable_type: question.class, votable_id: question.id, user: @user) }

      it "doesn't create new user's vote for resource" do
        expect { vote_down }.to_not change(question.votes, :count)
      end

      it "decrease value user's vote by 1" do
        vote_down
        expect(question.votes.first.value).to eq 0
      end

      it 'respond with json' do
        vote_down
        expect(response.body).to eq question.votes.first.to_json
      end
    end

    context 'try vote up twice' do
      before { create(:vote, :up, votable_type: question.class, votable_id: question.id, user: @user) }

      it "doesn't create new user's vote for resource" do
        expect { vote_up }.to_not change(question.votes, :count)
      end

      it "doesn't increase value of vote more than 1" do
        vote_up
        expect(question.votes.first.value).to eq 1
      end

      it 'respond with json' do
        vote_up
        expect(response.body).to eq ''
      end
    end

    context 'try vote down twice' do
      before { create(:vote, :down, votable_type: question.class, votable_id: question.id, user: @user) }

      it "doesn't create new user's vote for resource" do
        expect { vote_down }.to_not change(question.votes, :count)
      end

      it "doesn't increase value of vote more than 1" do
        vote_down
        expect(question.votes.first.value).to eq -1
      end

      it 'respond with json' do
        vote_down
        expect(response.body).to eq ''
      end
    end

    context 'by author of resource' do
      let(:question) { create(:question, user: @user) }

      it "doesn't create new user's vote for resource" do
        expect { vote_up }.to_not change(question.votes, :count)
      end

      it 'respond with nothing' do
        vote_up
        expect(response.body).to eq ''
      end

      it 'respond with status 403' do
        vote_up
        expect(response).to have_http_status 403
      end
    end
  end
end
