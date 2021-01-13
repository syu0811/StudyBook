class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable

  has_one_attached :image, dependent: :destroy

  has_many :notes, dependent: :destroy

  has_many :deleted_notes, dependent: :destroy
  has_many :my_lists, dependent: :destroy

  has_many :subscribe_my_lists, dependent: :destroy
  has_many :subscribe_my_list_my_lists, through: :subscribe_my_lists, source: :my_lists
  has_many :agents

  # 名前は全角平仮名、漢字（鬼車）のみ許可
  VALID_NAME_REGEX = /\A(?:\p{Hiragana}|[ー－]|[一-龠々])+\z/.freeze
  validates :firstname, presence: true, format: { with: VALID_NAME_REGEX }
  validates :lastname, presence: true, format: { with: VALID_NAME_REGEX }
  VALID_NICKNAME_REGEX = /\A[0-9A-Za-z_-]+\z/.freeze
  validates :nickname, presence: true, length: { in: 4..30 }, uniqueness: true, format: { with: VALID_NICKNAME_REGEX }
  validates :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future
  validates :admin, inclusion: { in: [true, false] }
  validate :image_size, if: :was_attached?

  private

  IMAGE_EXTENSION = ['image/png', 'image/jpg', 'image/jpeg'].freeze

  def was_attached?
    image.attached?
  end

  def image_size
    errors.add(:image, "の拡張子が間違っています") unless image.content_type.in?(IMAGE_EXTENSION)
    errors.add(:image, 'のサイズは10MB以下です') if image.blob.byte_size > 10000000
  end

  def birthdate_cannot_be_in_the_future
    # 生年月日が入力済かつ未来日ではない
    errors.add(:birthdate, :birthdate_cannot_be_in_the_future) if birthdate.present? && birthdate.future?
  end
end
