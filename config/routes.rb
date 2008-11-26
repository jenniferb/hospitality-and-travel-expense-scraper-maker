
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "departments", :action =>"index"

  # See how all your routes lay out with "rake routes"
  map.resources :departments do |department|
      department.send_package 'send_package', :controller => "departments", :action => "send_package", :requirements => { :method => :put }
      department.done 'done', :controller => "departments", :action => "done", :requirements => { :method => :put }

      department.resources :link_levels do |link_level|
            link_level.create_template 'create_template', :controller => "link_levels", :action => "create_template", :requirements => { :method => :put }
            link_level.create_scraper 'create_scraper', :controller => "link_levels", :action => "create_scraper", :requirements => { :method => :put }
            link_level.verify_template 'verify_template', :controller => "link_levels", :action => "verify_template", :requirements => { :method => :put }
            link_level.verify_scraper 'verify_scraper', :controller => "link_levels", :action => "verify_scraper", :requirements => { :method => :put }
            link_level.confirm 'confirm', :controller => "link_levels", :action => "confirm", :requirements => { :method => :put }
      end
      department.resources :split_levels do | split_level |
            split_level.create_template 'create_template', :controller => "split_levels", :action => "create_template", :requirements => { :method => :put }
            split_level.create_scraper 'create_scraper', :controller => "split_levels", :action => "create_scraper", :requirements => { :method => :put }
            split_level.verify_template 'verify_template', :controller => "split_levels", :action => "verify_template", :requirements => { :method => :put }
            split_level.verify_scraper 'verify_scraper', :controller => "split_levels", :action => "verify_scraper", :requirements => { :method => :put }
            split_level.confirm 'confirm', :controller => "split_levels", :action => "confirm", :requirements => { :method => :put }
      end
      department.resources :travel_details do | travel_detail |
            travel_detail.create_template 'create_template', :controller => "travel_details", :action => "create_template", :requirements => { :method => :put }
            travel_detail.create_scraper 'create_scraper', :controller => "travel_details", :action => "create_scraper", :requirements => { :method => :put }
            travel_detail.verify_template 'verify_template', :controller => "travel_details", :action => "verify_template", :requirements => { :method => :put }
            travel_detail.verify_scraper 'verify_scraper', :controller => "travel_details", :action => "verify_scraper", :requirements => { :method => :put }
            travel_detail.confirm 'confirm', :controller => "travel_details", :action => "confirm", :requirements => { :method => :put }
            travel_detail.confirm 'test', :controller => "travel_details", :action => "test", :requirements => { :method => :put }
 
      end
      department.resources :hospitality_details do | hospitality_detail |
            hospitality_detail.create_template 'create_template', :controller => "hospitality_details", :action => "create_template", :requirements => { :method => :put }
            hospitality_detail.create_scraper 'create_scraper', :controller => "hospitality_details", :action => "create_scraper", :requirements => { :method => :put } 
            hospitality_detail.verify_template 'verify_template', :controller => "hospitality_details", :action => "verify_template", :requirements => { :method => :put }
            hospitality_detail.verify_scraper 'verify_scraper', :controller => "hospitality_details", :action => "verify_scraper", :requirements => { :method => :put }
            hospitality_detail.confirm 'confirm', :controller => "hospitality_details", :action => "confirm", :requirements => { :method => :put }
            hospitality_detail.confirm 'test', :controller => "hospitality_details", :action => "test", :requirements => { :method => :put }
      end      
    end


  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
