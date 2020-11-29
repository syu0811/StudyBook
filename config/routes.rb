Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :users, only: [:show, :edit, :update], param: :nickname do
    scope module: :users do
      resources :my_lists, only: [:index]
      resources :notes, only: [:index]
      post '/subscribe_my_lists/:my_list_id', to: "subscribe_my_lists#create", as: :create_subscribe_my_list
      delete '/subscribe_my_lists/:my_list_id', to: "subscribe_my_lists#destroy", as: :destroy_subscribe_my_list
    end
  end

  resources :notes, only: [:index, :show]
  resources :admin, only: [:index]
  resources :my_lists, only: [:index, :show, :create, :edit, :update, :destroy]
  get '/my_lists/new/:note_id', to: 'my_lists#new', as: :new_my_list

  resources :my_list_notes, only: [:update]
  post '/my_list_notes', to: 'my_list_notes#create', as: :create_my_list_note
  delete '/my_list_notes', to: 'my_list_notes#destroy', as: :destroy_my_list_note

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post 'users/token', to: 'users#token', as: 'token_user'
        post 'users/auth', to: 'users#auth', as: 'token_auth'

        post 'notes/uploads', to: 'notes#uploads', as: 'upload_notes'
        get 'notes/downloads', to: 'notes#downloads', as: 'download_notes'
        delete 'notes', to: 'notes#destroys', as: 'delete_notes'
        resources :tags, only: :index
        resources :categories, only: :index
        get 'my_lists', to: 'my_lists#index', as: 'my_lists'
      end
    end
  end

  resources :admin, only: [:index]
  namespace :admin do
    resources :tags, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :notes, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  root 'users#show'
end
