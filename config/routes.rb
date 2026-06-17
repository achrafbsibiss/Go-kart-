require "sidekiq/web"

Rails.application.routes.draw do
  # Reveal health status on /up.
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA: dynamic manifest + service worker rendered from app/views/pwa/*.
  get "service-worker" => "pwa#service_worker", as: :pwa_service_worker
  get "manifest"       => "pwa#manifest", as: :pwa_manifest

  # Provider-agnostic payment webhook (locale-independent).
  post "payments/webhook" => "payments#webhook", as: :payment_webhook

  scope "(:locale)", locale: /en|fr|ar/ do
    devise_for :users

    root "home#index"
    get "offline" => "home#offline", as: :offline

    # --- Public marketing site ---
    get "about" => "venue#show", as: :about
    resources :karts, only: %i[index show]
    resources :pricing, only: :index
    resources :memberships, only: :index
    resources :competitions, only: %i[index show] do
      resources :registrations, only: %i[new create], module: :competitions
    end
    resources :events, only: %i[index show] do
      resources :registrations, only: %i[new create], module: :events
    end
    resources :gallery, only: :index
    resource :contact, only: %i[show create], controller: "contact"

    # --- Live racing + stats (public, realtime) ---
    resources :races, only: %i[index show]
    get "live" => "races#index", as: :live
    resources :leaderboards, only: :index
    get "records" => "records#index", as: :records
    resources :drivers, only: %i[index show]

    # --- Customer dashboard ---
    namespace :account do
      get "/" => "dashboard#show", as: :dashboard
      resources :bookings
      resources :registrations, only: %i[index show]
      resources :subscriptions, only: %i[index create]
      resource :profile, only: %i[show edit update]
    end

    # --- Admin / race management ---
    namespace :admin do
      get "/" => "dashboard#show", as: :dashboard
      resources :races do
        member do
          post :start
          post :finish
        end
        resources :race_entries, only: %i[create destroy]
      end
      resources :competitions
      resources :events
      resources :kart_types
      resources :session_prices
      resources :membership_plans
      resources :tracks
      resources :gallery_items
      resources :drivers
      resources :bookings, only: %i[index show update]
      resources :registrations, only: %i[index show update]
    end
  end

  # Background jobs dashboard (lock down before production).
  mount Sidekiq::Web => "/sidekiq"
end
