class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, :user_id, presence: true

  def need_confirm?
    providers = ['twitter']
    return providers.include?(self.provider) && !self.confirmed?
  end
end
