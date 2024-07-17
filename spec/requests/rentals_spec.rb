require 'rails_helper'

RSpec.describe 'Rentals', type: :request do
  let(:book) { create(:book, available_copies: 5) }
  let(:user) { create(:user) }
  let(:rental) { create(:rental, book: book, user: user) }
  let(:valid_attributes) { { book_id: book.id, user_id: user.id, returned_on: nil } }
  let(:invalid_attributes) { { book_id: nil, user_id: nil, returned_on: nil } }

  describe 'POST /rentals' do
    it 'creates a new rental and returns a JSON response' do
      post '/rentals', params: { rental: valid_attributes }, as: :json
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json_response['book_id']).to eq(valid_attributes[:book_id])
      expect(json_response['user_id']).to eq(valid_attributes[:user_id])
    end

    it 'returns an error when parameters are invalid' do
      post '/rentals', params: { rental: invalid_attributes }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /rentals/:id' do
    it 'returns the rental details' do
      get "/rentals/#{rental.id}", as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json_response['book_id']).to eq(rental.book_id)
    end

    it 'returns not found if rental does not exist' do
      get '/rentals/999', as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /rentals/:id' do
    it 'updates the rental and returns a JSON response' do
      patch "/rentals/#{rental.id}", params: { rental: { returned_on: Time.current } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['returned_on']).to_not be_nil
    end

    it 'returns an error when parameters are invalid' do
      patch "/rentals/#{rental.id}", params: { rental: { book_id: nil } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /rentals/:id' do
    it 'deletes the rental' do
      rental = create(:rental, book: book, user: user) 
      expect {
        delete "/rentals/#{rental.id}", as: :json
      }.to change(Rental, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
  
  describe 'POST /rentals/rent_book' do
    before do
      create(:rental, book: book, user: user) 
    end
    it 'decrements available copies and creates a rental record' do
      post '/rentals/rent_book', params: { book_id: book.id, user_id: user.id }, as: :json
      book.reload
      expect(book.available_copies).to eq(4)
      expect(Rental.count).to eq(2)  
      expect(Rental.last.user).to eq(user)
      expect(Rental.last.book).to eq(book)
    end
  
    it 'does not rent if no copies are available' do
      book.update!(available_copies: 0)
      post '/rentals/rent_book', params: { book_id: book.id, user_id: user.id }, as: :json
      book.reload
      expect(book.available_copies).to eq(0)
      expect(Rental.count).to eq(1) 
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'POST /rentals/return_book' do
    it 'increments available copies and updates rental record' do
      post '/rentals/return_book', params: { rental_id: rental.id }, as: :json
      book.reload
      rental.reload
      expect(book.available_copies).to eq(6) 
      expect(rental.returned_on).not_to be_nil
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
