class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :isbn, :available_copies, :available?
end

