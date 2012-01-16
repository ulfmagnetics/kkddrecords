Killkilldiedie::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :albums
  resources :bands
  get 'bands/autocomplete_band_name'
  resources :explosions
  resources :tracks

  root :to => 'home#index'

end
