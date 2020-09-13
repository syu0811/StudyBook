class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  # 名前は全角平仮名、漢字（鬼車）のみ許可
  VALID_NAME_REGEX = /\A(?:\p{Hiragana}|[ー－]|[一-龠々])+\z/.freeze
  validates :firstname, presence: true, format: { with: VALID_NAME_REGEX }
  validates :lastname, presence: true, format: { with: VALID_NAME_REGEX }
  VALID_NICKNAME_REGEX = /\A[0-9A-Za-z_-]+\z/.freeze
  validates :nickname, presence: true, length: { in: 4..30 }, uniqueness: true, format: { with: VALID_NICKNAME_REGEX }
  validates :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future
  validates :admin, inclusion: { in: [true, false] }

  def birthdate_cannot_be_in_the_future
    # 生年月日が入力済かつ未来日ではない
    errors.add(:birthdate, :birthdate_cannot_be_in_the_future) if birthdate.present? && birthdate.future?
  end
end
