class RentalSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :user_id, :rented_on, :returned_on, :user_name, :book_title
end

