Rails.application.routes.draw do
  resources :users, only: %i[create show update destroy]
  resources :books 
resources :rentals, only: [:destroy, :show, :create, :update] do
  collection do
    post :rent_book
    post :return_book
  end
end
end
