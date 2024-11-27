Rails.application.routes.draw do
  devise_for :users

  # Utilizza `resources` per generare tutte le rotte necessarie per gli eventi
  resources :events do
    resources :event_participations, only: [:new, :create]
    resources :invitations, only: [:create, :update]
  end

  # La rotta per verificare lo stato di salute dell'applicazione
  get "up" => "rails/health#show", as: :rails_health_check

  # Rotta per confermare l'invito con un token unico
  get 'confirm_invitation/:token', to: 'invitations#confirm', as: 'confirm_invitation'

  # Spazio admin per la dashboard e la gestione degli eventi e degli utenti
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

  # Rotta root
  root 'events#index'
end