Rails.application.routes.draw do
  namespace "api", :defaults => { :format => "json" } do
    resources :projects, :only => [:index, :show]
    resource  :real_time_data, :only => :show
  end
end
