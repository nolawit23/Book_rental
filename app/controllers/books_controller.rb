class BooksController < ApplicationController
   
    def index
      @books = Book.all
      render json: @books
    end
  
    def show
      @book = Book.find(params[:id])
      render json: @book
    end

    def create
      @book = Book.new(book_params)
  
      if @book.save
        render json: @book, status: :created, location: @book
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @book = Book.find(params[:id])
  
      if @book.update(book_params)
        render json: @book
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @book = Book.find(params[:id])
      @book.destroy
      head :no_content
    end
  
    private
  
    def book_params
      params.require(:book).permit(:title, :author, :available_copies, :isbn)
    end
  end
  