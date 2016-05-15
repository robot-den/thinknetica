require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
end
