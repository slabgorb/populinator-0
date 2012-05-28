Population::Application.routes.draw do
  
  get '/' => 'settlements#index'
  
  get '/people/random-name' => 'people#random_name'
  get '/settlements/random-name' => 'settlements#random_name'

  resources :events

  resources :settlements
  resources :damages
  resources :beings do
    resources :things
  end
  resources :things 
  resources :people, :controller => 'beings',  :_type => 'Person'
  resources :rulers, :controller => 'beings',  :_type => 'Ruler'
  
  
  get '/being/graph' => 'beings#graph'
  
  put '/settlement/seed/:id' => 'settlements#seed', :as => :seed
  
end
