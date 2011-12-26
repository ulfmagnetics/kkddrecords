Killkilldiedie::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :s3_uploads

  resources :bands
  get 'bands/autocomplete_band_name'

  resources :explosions
  
  root :to => 'home#index'
end
