class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :rented_on, presence: true
  validates :returned_on, presence: true, if: -> { returned_on.present? }
  validate :returned_on_after_rented_on
  delegate :name, to: :user, prefix: true
  delegate :title, to: :book, prefix: true
  private

  def returned_on_after_rented_on
    if returned_on.present? && rented_on.present? && returned_on < rented_on
      errors.add(:returned_on, "must be after rented_on")
    end
  end
end

