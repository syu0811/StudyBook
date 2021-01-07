class Agent < ApplicationRecord
  belongs_to :user
  before_create :add_guid


  def add_guid
    self.guid = SecureRandom.uuid
  end
end
