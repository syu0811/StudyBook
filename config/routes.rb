Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :users, only: [:show], param: :nickname do
    scope module: :users do
      resources :my_lists, only: [:index]
      resources :notes, only: [:index]
    end
  end

  resources :admin, only: [:index]
  resources :notes, only: [:index], param: :category
  resources :my_lists, only: [:index, :show, :create, :edit, :update, :destroy]
  get '/my_lists/new/:note_id', to: 'my_lists#new', as: :new_my_list

  resources :my_list_notes, only: [:update]
  post '/my_list_notes', to: 'my_list_notes#create', as: :create_my_list_note
  delete '/my_list_notes', to: 'my_list_notes#destroy', as: :destroy_my_list_note

  namespace :admin do
    resources :tags, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  root 'users#show'
end
