Rails.application.routes.draw do


  root 'pages#index'
  get 'marcas/:id' => 'pages#getbrands'
  get 'marcas/' => 'pages#getbrands'


  get 'marcasrespuestos/:id' => 'pages#getbrandsextra'
  get 'marcasrespuestos/' => 'pages#getbrandsextra'






  get 'camion/:id-:link' => 'pages#camion', :as =>'camion'
  get 'camiones' => 'pages#camiones'
  get 'camiones/:param1' => 'pages#camiones'
  get 'camiones/:param1/:param2' => 'pages#camiones'
  get 'camiones/:param1/:param2/:param3' => 'pages#camiones'



  get 'repuesto/:id-:link' => 'pages#repuesto', :as =>'repuesto'
  get 'repuestos' => 'pages#repuestos'
  get 'repuestos/:param1' => 'pages#repuestos'
  get 'repuestos/:param1/:param2' => 'pages#repuestos'
  get 'repuestos/:param1/:param2/:param3' => 'pages#repuestos'



  devise_for :users

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :trucks,  :type_truck, :brands_truck, :brand_extra, :type_extra, :extras, :type_service, :services



    resources :states do
       resources :cities
    end


  end

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
end
