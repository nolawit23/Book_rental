class Book < ApplicationRecord
    validates :title, presence: true
    validates :author, presence: true
    validates :isbn, presence: true, uniqueness: true, length: { is: 13 }
    validates :available_copies, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
    def available?
      available_copies > 0
    end
  end
  
  
  
