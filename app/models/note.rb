class Note < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :note_tags, dependent: :destroy
  has_many :tags, through: :note_tags

  has_many :my_list_notes, dependent: :destroy
  has_many :my_lists, through: :my_list_notes

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 30000 }
  validates :directory_path, length: { maximum: 255 }

  before_create :add_guid
  before_destroy :move_deleted_note

  scope :full_search, ->(query) { where('notes.title @@ ? OR notes.body @@ ?', query, query) }

  def add_guid
    self.guid = SecureRandom.uuid
  end

  def move_deleted_note
    throw(:abort) unless DeletedNote.note_save(guid, user_id)
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

  class << self
    def upload(user_id, guid, note_params, tags)
      note = find_by(guid: guid, user_id: user_id)
      if note
        note.attributes = note_params
      else
        note = new(note_params.merge(user_id: user_id))
      end

      return { guid: nil, errors: note.errors.details, tag_errors: [] } unless note.save

      { guid: note.guid, errors: note.errors.details, tag_errors: note.create_note_tags(tags) }
    end

    def directory_tree
      directory_tree = {}
      pluck(:directory_path).uniq.sort.each do |path|
        create_folders(path, directory_tree)
      end
      directory_tree
    end

    private

    def create_folders(directory_path, directory_tree, relative_path = Pathname(''))
      dir_name, child_path = directory_path.split('/', 2)
      relative_path = relative_path.join(dir_name)
      directory_tree[dir_name.to_sym] ||= { path: relative_path.to_path, name: dir_name }
      return unless child_path

      directory_tree[dir_name.to_sym][:children] ||= {}
      create_folders(child_path, directory_tree[dir_name.to_sym][:children], relative_path)
    end
  end
end
