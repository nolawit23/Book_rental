require 'rails_helper'

RSpec.describe Book, type: :model do
  before do
    Book.create!(title: "Psstion of the christ", isbn: "1234567890123", author: "Matiw", available_copies: 10)
  end

  let(:book) { build(:book) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:isbn) }
    it { should validate_uniqueness_of(:isbn).case_insensitive }  
    it { should validate_length_of(:isbn).is_equal_to(13) }
    it { should validate_presence_of(:available_copies) }
    it { should validate_numericality_of(:available_copies).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '#available?' do
    it 'returns true if available_copies is greater than 0' do
      book.available_copies = 5
      expect(book.available?).to be_truthy
    end

    it 'returns false if available_copies is 0' do
      book.available_copies = 0
      expect(book.available?).to be_falsey
    end
  end
end
