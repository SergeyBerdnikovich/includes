Includes::Application.routes.draw do




  resources :category_products


  mount Rich::Engine => '/rich', :as => 'rich'

  resources :categories


  resources :images


  resources :products


  resources :alerts


  resources :alers


  match "/plans/card", :to => "plans#card"
  resources :plans


  resources :accounts


  resources :option_types


  resources :bigcommerce_accounts


  resources :include_options


  resources :includeoptions


  resources :options


  resources :brands


  resources :include_types


  resources :statistics

  
  match "/statistic/show", :to => "statistics#show"
  match "/users/attach", :to => "users#attach"
  match "/includes/get_options", :to => "includes#get_options"
  resources :includes 
  


  mount StripeEvent::Engine => '/stripe'

  get "content/gold"
  get "content/silver"
  get "content/platinum"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  get "dashboard", :to => 'dashboard#index'

  get "includes", :to => 'dashboard#inclu'


  devise_for :users, :controllers => { :registrations => 'registrations' }

  devise_scope :user do
    put 'update_plan', :to => 'registrations#update_plan'
    put 'update_card', :to => 'registrations#update_card'
  end
  resources :users

  ActiveAdmin.routes(self)
    devise_for :admin_users, ActiveAdmin::Devise.config
end