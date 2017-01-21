Rails.application.routes.draw do
  root :to => "homes#show"

  resource :home, :only => :show

  namespace "api", :defaults => { :format => "json" } do
    resources :projects, :only => [:index, :show]
    resource  :real_time_data, :only => :show
  end
end
