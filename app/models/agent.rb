class Agent < ApplicationRecord
  belongs_to :user
  before_create :add_guid

  validates :guid, uniqueness: true#, presence: true
  validates :user_id, presence: true

  def add_guid
    self.guid = SecureRandom.uuid
  end
end
