Rails.application.routes.draw do
  #devise_for :admins

  devise_for :admin, :controllers => {registrations: "devise/registrations" }
    devise_scope :admin do
    get '/admin/sign_out' => 'devise/sessions#destroy' 
    get 'login', :to => 'devise/sessions#new'
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :categories

  post  'user',                   to:  'users#create'
  get   'users',                  to:  'users#index'
 
  post  'category',               to:  'categories#index1'
  post  'user/category',          to:  'users#user_category'
  get   'category/user',          to:  'users#category_user'
  post  'category/game',          to:  'categories#category_game'
  post  'user/category/edit',     to:  'users#user_category_edit'
 
  post  'game/question',          to:  'games#game_question'
  post  'question/answer',        to:  'users#question_answer'

  post 'category/check',          to:  'categories#category_check'
    
  post 'charges',                 to:  'charges#charges'
  post 'recharge',                to:  'charges#recharge'
  post 'bank/details',            to:  'charges#update_bank_details'
  post 'calculate',               to:  'users#calculate'
  
  get 'live',                     to:  'games#live'
  put 'testing_live',             to:  'games#testing_live'
  put 'deleting_live',            to:  'games#deleting_live'

  post 'image',                   to:  'users#testing_image'

  resources :games 
    # member do 
    #   put :testing_live
    # end
  #end
  resources :questions
  resources :accounts
  resources :locations

  root to: "games#index"
end
