Rails.application.routes.draw do
  devise_for :users

  resources :events do
    resources :guest_event_participations, only: [:destroy]
    resources :event_participations, only: [:new, :create] do
      member do
        delete 'destroy_guest/:id', to: 'event_participations#destroy_guest', as: 'destroy_guest'
      end
    end    
    resources :invitations, only: [:edit, :create, :update, :destroy] do
      member do
        get 'confirm'
        post 'respond'
      end
    end
    member do
      post 'send_invites'
      delete 'events/:event_id/cancel_invite/:invitation_id', to: 'events#cancel_invite', as: 'cancel_invite'
      # delete 'cancel_invite/:id', to: 'events#cancel_invite', as: 'cancel_invite'
    end
  end

  get 'confirm_invitation/:token', to: 'invitations#confirm', as: 'confirm_invitation'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :event_types, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  root 'events#index'
end