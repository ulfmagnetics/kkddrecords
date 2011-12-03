Killkilldiedie::Application.routes.draw do
  resources :s3_uploads

  resources :bands
  get 'bands/autocomplete_band_name'

  resources :explosions
end
