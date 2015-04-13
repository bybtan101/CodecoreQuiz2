Rails.application.routes.draw do

  devise_for :users
  namespace :admin do
    get 'questions/index'
  end

  # Rails know where to routes you based on the combination of the 
  # HTTP VERB and the PATH. So HTTP VERB / PATH combo must be
  # unique. Otherwise, it will pick the first match.
  # VERB   PATH                     "CONTROLLER#ACTION"   HELPER
  # get    "/questions"          => "questions#index"
  # get    "/questions/new"      => "questions#new", as: :new_question
  # post   "/questions"          => "questions#create"
  # get    "/questions/:id"      => "questions#show", as: :question
  # get    "/questions/:id/edit" => "questions#edit", as: :edit_question
  # patch  "/questions/:id"      => "questions#update"
  # put    "/questions/:id"      => "questions#update"
  # delete "/questions/:id"      => "questions#destroy"
  resources :questions do
    # post "/questions/:question_id/answers" => "answers#create"
    # putting resources :answers within this block
    # will make answers a nested resources under questions
    # This will prefix all the routes for answers with:
    # /questions/:question_id
    resources :answers

    resources :likes, only: [:create, :destroy]

    resources :favourites, only: [:create, :destroy]

    resources :votes, only: [:create, :update, :destroy]
  end

  # We've put the index of favourites controller outside of the 
  # question resources block because we want to show the favourites
  # for the user and not for a specific question
  resources :favourites, only: [:index]

  # resources is a method that comes with Rails and it generates
  # standard routes for the seven standards Rails actions:
  # index / show / new / create / edit / update / destroy

  # the as: :about defines a helper method that can be
  # used inside the views and controllers.
  # So instead of having to manually type:
  # link_to "About", "/about"
  # you can do:
  # link_to "About", about_path
  get "/about" => "about#index", as: :about

  get "/contact"  => "contact#index", as: :contact
  post "/contact" => "contact#create"

  get "/welcome/:name" => "welcome#show", as: :welcome

  # if this route is put after the one: get "/welcome/:name"
  # you will never end up using this route. Simple because
  # the one with the :name will match before this one
  get "/welcome/hello" => "welcome#hello", as: :hello_welcome


  # all the routes inside the scope block
  # will have a "/admin" prefix
  # scope :admin do
  #   # even inside a scope this will still look for 
  #   # questions_controller
  #   get "/questions" => "questions#index"
  # end

  # all the routes inside the admin namespace
  # will have a "/admin" prefix
  # Also, it will look for the controllers
  # inside an "admin" folder inside the "controllers"
  # folder
  namespace :admin do
    get "/questions" => "questions#index"
  end



  # this will be the home page of the application.
  # for instance: http://localhost:3000/
  root "contact#index"

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
