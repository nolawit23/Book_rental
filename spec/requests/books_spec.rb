require 'rails_helper'

RSpec.describe BooksController, type: :controller do
 
  let(:valid_attributes) {
    { title: 'the Passtion of christ', author: 'Matiw', available_copies: 3, isbn: '1234567890123' }
  }

  let(:invalid_attributes) {
    { title: '', author: '', available_copies: -1, isbn: '123' }
  }

  describe "GET #index" do
    it "returns a success response" do
      Book.create!(valid_attributes)
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end
    
  describe "GET #show" do
    it "returns a success response" do
      book = Book.create!(valid_attributes)
      get :show, params: { id: book.to_param }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)['title']).to eq('the Passtion of christ')
    end
  end

 
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Book" do
        expect {
          post :create, params: { book: valid_attributes }
        }.to change(Book, :count).by(1)
      end

      it "renders a JSON response with the new book" do
        post :create, params: { book: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['title']).to eq('the Passtion of christ')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Book" do
        expect {
          post :create, params: { book: invalid_attributes }
        }.to change(Book, :count).by(0)
      end
      it "renders a JSON response with errors for the new book" do
        post :create, params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"], "author" => ["can't be blank"], "available_copies" => ["must be greater than or equal to 0"], "isbn" => ["is the wrong length (should be 13 characters)"])
      end      
    end
  end


  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      it "updates the requested book" do
        book = Book.create!(valid_attributes)
        new_attributes = { title: 'the Passtion of christ' }
        put :update, params: { id: book.to_param, book: new_attributes }
        book.reload
        expect(book.title).to eq('the Passtion of christ')
      end

      it "renders a JSON response with the book" do
        book = Book.create!(valid_attributes)
        new_attributes = { title: 'the Passtion of christ' }
        put :update, params: { id: book.to_param, book: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['title']).to eq('the Passtion of christ')
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the book" do
        book = Book.create!(valid_attributes)
        put :update, params: { id: book.to_param, book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"], "author" => ["can't be blank"], "available_copies" => ["must be greater than or equal to 0"], "isbn" => ["is the wrong length (should be 13 characters)"])
      end      
    end
  end


  describe "DELETE #destroy" do
    it "destroys the requested book" do
      book = Book.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: book.to_param }
      }.to change(Book, :count).by(-1)
    end

    it "returns no content response" do
      book = Book.create!(valid_attributes)
      delete :destroy, params: { id: book.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
