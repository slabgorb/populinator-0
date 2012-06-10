Population::Application.routes.draw do
  
  resources :buildings

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
  
  # beings
  get '/beings/graph' => 'beings#graph'
  put '/beings/randomize_genetics/:id' => 'beings#randomize_genetics', :as => :random_genetics
  put '/beings/kill/:id' => 'beings#kill', :as => :kill
  put '/beings/resurrect/:id' => 'beings#resurrect', :as => :resurrect
  put '/beings/age/:id' => 'beings#age', :as => :age
  put '/beings/reproduce/:parent_a/:parent_b' => 'beings#reproduce', :as => :reproduction
  get '/beings/genotype/:id' => 'beings#genotype'
  get '/beings/family/:id' => 'beings#family'
  get '/beings/description/:id' => 'beings#description'
  get '/beings/history/:id' => 'beings#history'
  
  
  put '/settlement/seed/:id' => 'settlements#seed', :as => :seed
  
end
