require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without a firstname" do
    user = build(:user, firstname: nil)
    user.valid?
    expect(user.errors[:firstname]).to include("を入力してください")
  end

  it "is not valid with a katakana firstname" do
    user = build(:user, firstname: "カタカナ")
    user.valid?
    expect(user.errors[:firstname]).to include("は不正な値です")
  end

  it "is not valid with an alphabet firstname" do
    user = build(:user, firstname: "name")
    user.valid?
    expect(user.errors[:firstname]).to include("は不正な値です")
  end

  it "is not valid without a lastname" do
    user = build(:user, lastname: nil)
    user.valid?
    expect(user.errors[:lastname]).to include("を入力してください")
  end

  it "is not valid with a katakana lastname" do
    user = build(:user, lastname: "カタカナ")
    user.valid?
    expect(user.errors[:lastname]).to include("は不正な値です")
  end

  it "is not valid with an alphabet lastname" do
    user = build(:user, lastname: "name")
    user.valid?
    expect(user.errors[:lastname]).to include("は不正な値です")
  end

  it "is not valid without a nickname" do
    user = build(:user, nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include("を入力してください")
  end

  it "is not valid with a not unique nickname" do
    nickname = "test_nick-name"
    create(:user, nickname: nickname)
    user = build(:user, nickname: nickname)
    user.valid?
    expect(user.errors[:nickname]).to include("はすでに存在します")
  end

  it "is not valid with a Japanese nickname" do
    user = build(:user, nickname: '日本語')
    user.valid?
    expect(user.errors[:nickname]).to include("は不正な値です")
  end

  it "is not valid with a illegal sign nickname" do
    user = build(:user, nickname: '\\')
    user.valid?
    expect(user.errors[:nickname]).to include("は不正な値です")
  end

  it "is not valid with a 3 characters or less nickname" do
    user = build(:user, nickname: 'a' * 3)
    user.valid?
    expect(user.errors[:nickname]).to include("は4文字以上で入力してください")
  end

  it "is not valid with a 31 characters or more nickname" do
    user = build(:user, nickname: 'a' * 31)
    user.valid?
    expect(user.errors[:nickname]).to include("は30文字以内で入力してください")
  end

  it "is not valid without a birthdate" do
    user = build(:user, birthdate: nil)
    user.valid?
    expect(user.errors[:birthdate]).to include("を入力してください")
  end

  it "is not valid with a future birthdate" do
    user = build(:user, birthdate: 1.days.since)
    user.valid?
    expect(user.errors[:birthdate]).to include("は正しい範囲で設定してください")
  end

  it "is not valid without an email" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is not valid with an invalid format email" do
    user = build(:user, email: 'emailcom')
    user.valid?
    expect(user.errors[:email]).to include("は不正な値です")
  end

  it "is not valid with a not unique email" do
    email = "test@example.com"
    create(:user, email: email)
    user = build(:user, email: email)
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "is not valid without a password" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "is not valid with a 129 characters or more password" do
    user = build(:user, password: 'a' * 129)
    user.valid?
    expect(user.errors[:password]).to include("は128文字以内で入力してください")
  end

  it "is not valid with a 7 characters or less password" do
    user = build(:user, password: 'a' * 7)
    user.valid?
    expect(user.errors[:password]).to include("は8文字以上で入力してください")
  end

  it "is not valid without an admin" do
    user = build(:user, admin: nil)
    user.valid?
    expect(user.errors[:admin]).to include("は一覧にありません")
  end
end
