Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :bikes, param: :serial_number, only: [:create, :update, :index]
end
