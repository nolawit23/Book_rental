class RentalsController < ApplicationController
    before_action :set_rental, only: [:show, :update, :destroy]
  
    def rent_book
        book = Book.find(params[:book_id])
        user = User.find(params[:user_id])
        
        if book.available_copies > 0
          ActiveRecord::Base.transaction do
            book.update!(available_copies: book.available_copies - 1)
            Rental.create!(user: user, book: book, rented_on: Time.current) 
          end
          render json: { status: 'success', message: 'Book rented successfully' }
        else
          render json: { status: 'error', message: 'No copies available for rent' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { status: 'error', message: e.message }, status: :unprocessable_entity
      end
       
      
    def return_book
      rental = Rental.find(params[:rental_id])
      book = rental.book
      
      ActiveRecord::Base.transaction do
        book.update!(available_copies: book.available_copies + 1)
        rental.update!(returned_on: Time.current)
      end
  
      render json: { status: 'success', message: 'Book returned successfully' }
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    end
  
def create
    @rental = Rental.new(rental_params)
    @rental.rented_on = Time.current
    
    if @rental.save
      render json: @rental, status: :created
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end
  def show
    @rental = Rental.find_by(id: params[:id])
    if @rental
      render json: @rental
    else
      render json: { error: 'Rental not found' }, status: :not_found
    end
  end
  
    def update
      if @rental.update(rental_params)
        render json: @rental
      else
        render json: @rental.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @rental.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  
    private
  
    def set_rental
      @rental = Rental.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Rental not found' }, status: :not_found
    end
  
    def rental_params
      params.require(:rental).permit(:book_id, :user_id, :returned_on)
    end
  end
  