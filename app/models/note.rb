class Note < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :note_tags
  has_many :tags, through: :note_tags

  has_many :my_list_notes
  has_many :my_lists, through: :my_list_notes

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 30000 }
  validates :file_path, length: { maximum: 255 }

  before_create :add_uuid

  def add_uuid
    self.guid = SecureRandom.uuid
  end

  def self.upload(user_id, guid, note_params, tags)
    note = find_by(guid: guid, user_id: user_id)
    if note
      note.attributes = note_params
    else
      note = new(note_params.merge(user_id: user_id))
    end

    return { guid: nil, errors: note.errors.details, tag_errors: [] } unless note.save

    { guid: note.guid, errors: note.errors.details, tag_errors: note.create_note_tags(tags) }
  end

  def create_note_tags(tags)
    return [] if tags.blank?

    errors = []
    note_tags.destroy_all
    tags.each do |tag|
      tag_id = tag[:id].present? ? tag[:id] : Tag.create_or_find_by(name: tag[:name]).id
      errors.push(tag) unless note_tags.new(tag_id: tag_id).save
    end
    errors
  end
end
