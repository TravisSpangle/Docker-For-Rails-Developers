Rails.application.routes.draw do
  resources :users
  get 'welcome', to: 'welcome#index'
  get 'react', to: 'pages#home'
end
