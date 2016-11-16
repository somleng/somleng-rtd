Rails.application.routes.draw do
  root :to => redirect('https://github.com/dwilkie/somleng-rtd')

  namespace "api", :defaults => { :format => "json" } do
    resources :projects, :only => [:index, :show]
    resource  :real_time_data, :only => :show
  end
end
