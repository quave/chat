Chat::Application.routes.draw do

  mount Forem::Engine, :at => '/forums'

  resources :games, except: :destroy do
    put :start, on: :member
    put :stop, on: :member

    resources :rooms, except: :index do
      put :up, on: :member
      put :down, on: :member
      get :leave, on: :member

      resources :messages, only: [:index, :create, :destroy]
    end

    resources :characters, except: :index do
      patch :accept, on: :member
      patch :decline, on: :member
      patch :kill, on: :member
    end
  end
#  resource :profile, only: :update do
#    get '(/:name)', action: :show
#  end
  resources :online, only: [:create, :destroy]

  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations'},
             :skip => [:sessions, :registrations]
  as :user do
    # Registrations routes
    get '/profile(/:name)' => 'registrations#edit', as: :profile
    put '/profile' => 'registrations#update'
    patch '/profile' => 'registrations#update'
    get '/profile/cancel' => 'registrations#cancel', as: :cancel_profile
    get '/sing-up' => 'registrations#new', as: :new_user_registration
    post '/sing-up' => 'registrations#create', as: :user_registration
    # Sessions routes
    get '/sign-in' => 'sessions#new', :as => :new_user_session
    post '/sign-in' => 'sessions#create', :as => :user_session
    delete '/sign-out' => 'sessions#destroy', :as => :destroy_user_session
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'lobby#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
