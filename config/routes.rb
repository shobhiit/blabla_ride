Rails.application.routes.draw do

  #authentication routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  patch '/update_password', to: 'passwords#update'
  #send otp in mail for vefication
  post '/send_otp', to: 'password_reset#send_otp'
  post '/verify_otp', to: 'password_reset#verify_otp'
  post '/password_reset', to: 'password_reset#reset_password' 


  get 'chats/:chat_id', to: 'chats#get_chat'

  #messages routes
  resources :chats, only: [:index, :show, :create, :update, :destroy] do
    resources :messages, only: [:index, :show, :create, :update, :destroy]
  end
  


  


  #vehicle routes
  resources :vehicles
  get '/show_by_id/:id', to: 'vehicles#show_by_id'


  
  

  #users routes
  devise_scope :user do
    get '/users', to: 'users/registrations#show', as: :user_profile
   
    delete '/users', to: 'users/registrations#destroy'
    post '/verify', to: 'authentication#verify'
    post '/phone', to: 'authentication#phone'
    post '/phonesignup', to: 'authentication#phonesignup'
    get '/email_check', to:'users/registrations#email_check'
    get 'users/:id', to: 'users/sessions#find_user_by_id'

    
  end
  put '/user_images', to: 'user_images#update'
  get '/user_images', to: 'user_images#show'
  

  #publish a ride routesF
  resources :publishes do
    resources :passengers, only: [:create, :destroy]
  end


  post 'cancel_publish', to: 'publishes#cancel_publish'
  post 'publishes/:id/complete_publish', to: 'publishes#complete_publish'
  get '/publishes/:id', to: 'publishes#show', as: 'show_publish'

  #route for searching
  get '/search', to: 'searches#search'



  

  
 

  #email activation route
  post '/account_activations', to: 'account_activations#create'
  get '/account_activations/:activate_token/edit', to: 'account_activations#edit', as: 'edit_account_activation'



  post '/book_publish', to: 'passengers#book_publish'
  get '/booked_publishes', to: 'passengers#booked_publishes'
  post '/cancel_booking', to: 'passengers#cancel_booking'
  patch '/passengers/:id/complete_ride', to: 'passengers#complete_ride'



  





# routes for ratings
  resources :ratings, only: [:create]
  get '/givenRating', to: 'ratings#givenRating'
  get '/recievedRating', to: 'ratings#recievedRating'
 
  
end
