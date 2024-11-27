Rails.application.routes.draw do
  devise_for :users

  resources :events do
    resources :event_participations, only: [:new, :create]
    resources :invitations, only: [:create, :update] do
      member do
        get 'confirm'
        post 'respond'
      end
    end
  end

  get 'confirm_invitation/:token', to: 'invitations#confirm', as: 'confirm_invitation'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :events do
      member do
        get 'invite'
        post 'send_invites'
      end
    end
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :event_types, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  root 'events#index'
end