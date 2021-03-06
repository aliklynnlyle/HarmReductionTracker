Rails.application.routes.draw do
  
  scope "(:locale)", locale: /en|es/ do  
    devise_for :users, skip: [:sessions, :registrations]
    as :user do
      get '/', to: 'devise/sessions#new', as: :new_user_session
      post '/', to: 'devise/sessions#create', as: :user_session
      get '/logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # get "home", to: "home#home"
    get "qrscanner", to: "home#qrscanner"
    get "kitserials", to: "home#kitserials"
    resources :home
    get "admin", to: "home#admin"
    resources :inventories
    resources :users
    put "deactive", to: "users#toggle_deactivated", as: :deactive_user
    put "elevate", to: "users#toggle_admin", as: :elevate_user
    resources :reversals
    # resource :session, only: [:new, :create, :destroy]
    resources :clients
    get "l10n_es", to: "localize#to_es", as: :l10n_es
    get "l10n_en", to: "localize#to_en", as: :l10n_en
    root to: "home#index"

    # You can also override after_sign_in_path_for and
    # after_sign_out_path_for to customize your redirect hooks.
  end
end
