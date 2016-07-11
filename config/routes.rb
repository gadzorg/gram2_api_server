Rails.application.routes.draw do
  devise_for :clients, controllers: { sessions: 'clients/sessions' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  namespace :api, defaults: {format: :json} do
    namespace :v2 do
      resources :groups, param: :uuid do
        get 'accounts' => 'accounts#index'
      end
      resources :roles, param: :uuid
      resources :accounts, param: :uuid do
        #accounts/groups
        get 'groups' => 'groups#index'
        post 'groups' => 'accounts#add_to_group', as: :add_to_group
        delete 'groups/:group_id' => 'accounts#remove_from_group', as: :remove_from_group
        #accounts/roles
        get 'roles' => 'roles#index'
        post 'roles' => 'accounts#add_role', as: :add_role
        delete 'roles/:role_id' => 'accounts#revoke_role', as: :revoke_roles
      end
    end
  end

  resources :clients
end
