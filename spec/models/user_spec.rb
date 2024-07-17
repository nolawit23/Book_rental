require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    User.create!(email: "user@example.com", name: "Example User", password: "password123")
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should validate_presence_of(:password) }
  
  it 'should have a password digest attribute' do
    user = User.find_by(email: 'user@example.com')
    expect(user.password_digest).to_not be_nil
  end
end
