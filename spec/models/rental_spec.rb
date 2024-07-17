RSpec.describe Rental, type: :model do

  it { should belong_to(:user) }
  it { should belong_to(:book) }

  it { should validate_presence_of(:rented_on) }
  
  it 'validates presence of returned_on when it is set' do
    rental = build(:rental, rented_on: 1.day.ago, returned_on: nil)
    expect(rental).to be_valid

    rental.returned_on = 1.day.ago
    expect(rental).to be_valid

    rental.returned_on = nil
    rental.rented_on = 1.day.ago
    expect(rental).to be_valid
  end

  it 'is invalid if returned_on is before rented_on' do
    rental = build(:rental, rented_on: 1.day.ago, returned_on: 2.days.ago)
    expect(rental).not_to be_valid
    expect(rental.errors[:returned_on]).to include("must be after rented_on")
  end

  it 'is valid if returned_on is after rented_on' do
    rental = build(:rental, rented_on: 2.days.ago, returned_on: 1.day.ago)
    expect(rental).to be_valid
  end

  it 'is valid without a returned_on' do
    rental = build(:rental, rented_on: 1.day.ago, returned_on: nil)
    expect(rental).to be_valid
  end
end
