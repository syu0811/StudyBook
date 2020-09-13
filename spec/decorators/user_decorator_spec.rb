require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { create(:user).decorate }

  it 'return fullname' do
    expect(user.fullname).to eq "#{user.lastname} #{user.firstname}"
  end
end
