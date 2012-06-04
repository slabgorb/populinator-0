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
  
  
  get '/beings/graph' => 'beings#graph'
  
  put '/beings/kill/:id' => 'beings#kill', :as => :kill
  put '/beings/resurrect/:id' => 'beings#resurrect', :as => :resurrect
  
  get '/beings/genotype/:id' => 'beings#genotype'
  
  put '/settlement/seed/:id' => 'settlements#seed', :as => :seed
  
end
