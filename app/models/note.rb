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

  ORDER_LIST = { "create_asc" => "created_at", "create_desc" => "created_at DESC", "update_asc" => "updated_at", "update_desc" => "updated_at DESC", "name_asc" => "title", "name_desc" => "title DESC" }.freeze
  RELADED_NOTE_LIMIT = 6

  scope :specified_order, ->(sort_key) { order(sort_key.present? ? Note::ORDER_LIST[sort_key] : Note::ORDER_LIST["update_desc"]) }
  scope :full_search, ->(query) { where('notes.title @@ ? OR notes.body @@ ?', query, query) }
  scope :high_light_full_search, lambda { |query|
    full_search(query)
      .select("*, pgroonga_snippet_html(notes.body, pgroonga_query_extract_keywords('#{query}')) AS high_light_body")
  }
  scope :tags_search, lambda { |tag_params|
    tags = tag_params.split(',')
    tag_ids = Tag.where(name: tags).ids
    return none unless tags.size == tag_ids.size

    note_ids = NoteTag.where(tag_id: tag_ids).group(:note_id).having('count(*) = ?', tag_ids.size).pluck(:note_id)
    where(id: note_ids)
  }

  scope :category_ratio, lambda {
    joins(:category)
      .group("categories.name").order("categories.name").count
  }

  def add_guid
    self.guid = SecureRandom.uuid
  end

  def move_deleted_note
    throw(:abort) unless DeletedNote.note_save(guid, user_id)
  end

  def create_note_tags(tags)
    note_tags.destroy_all
    return [] if tags.blank?

    errors = []
    tags.each do |tag|
      tag_id = tag[:id].present? ? tag[:id] : Tag.find_or_create_by(name: tag[:name]).id
      errors.push(tag) unless note_tags.new(tag_id: tag_id).save
    end
    errors
  end

  def upload_note(word_count, is_create, tags)
    if save
      [{ guid: guid, errors: errors.details, tag_errors: create_note_tags(tags), note_id: id }, { note_id: id, word_count: word_count, is_create: is_create }]
    else
      [{ guid: nil, errors: errors.details, tag_errors: [], note_id: id }, nil]
    end
  end

  class << self
    def upload(user_id, guid, note_params, tags)
      note = find_by(guid: guid, user_id: user_id)
      word_count = note_params[:body].size
      if note
        word_count = (word_count - note.body.size).abs
        is_create = 'false'
        note.attributes = note_params
      else
        is_create = 'true'
        note = new(note_params.merge(user_id: user_id))
      end
      note.upload_note(word_count, is_create, tags)
    end

    def directory_tree
      directory_tree = {}
      pluck(:directory_path).uniq.sort.each do |path|
        create_folders(path, directory_tree)
      end
      directory_tree
    end

    def get_reladed_notes_list(looking_note)
      note_tags = NoteTag.where(tag_id: NoteTag.where(note_id: looking_note.id).pluck(:tag_id))
      if note_tags.blank?
        Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id).limit(RELADED_NOTE_LIMIT)
      else
        Note.includes(:user, :category, :tags).where("notes.category_id = ? AND notes.id IN (?)", looking_note.category_id, note_tags.pluck(:id)).where.not(id: looking_note.id).limit(RELADED_NOTE_LIMIT)
      end
    end

    def trend_notes(user_id, limit)
      number_read_per_note = ReadNoteLog.new(user_id).number_read_per_note(limit)
      note_ids = number_read_per_note.map { |x| x[:note_id].to_i }
      notes = includes(:user, :category).where(id: note_ids)
      note_ids.collect { |id| notes.detect { |note| note.id == id } }.compact
    end

    private

    def create_folders(directory_path, directory_tree, relative_path = Pathname(''))
      dir_name, child_path = directory_path.split('/', 2)
      return unless dir_name

      relative_path = relative_path.join(dir_name)
      directory_tree[dir_name.to_sym] ||= { path: relative_path.to_path, name: dir_name }
      return unless child_path

      directory_tree[dir_name.to_sym][:children] ||= {}
      create_folders(child_path, directory_tree[dir_name.to_sym][:children], relative_path)
    end
  end
end
