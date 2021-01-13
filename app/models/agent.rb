class Agent < ApplicationRecord
  belongs_to :user
  before_create :add_guid

  validates :user_id, presence: true
  validates :token, presence: true

  def add_guid
    self.guid = SecureRandom.uuid
  end
end
