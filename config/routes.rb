Population::Application.routes.draw do


  resources :buildings
  resources :things
  resources :damages
  resources :events
  resources :languages do
    resources :corpora
    resources :histograms
  end

  # settlements
  put '/settlement/seed/:id' => 'settlements#seed', :as => :seed
  resources :rulers, :controller => 'beings',  :_type => 'Ruler'
  get '/' => 'settlements#index'
  get '/settlements/random-name' => 'settlements#random_name'
  resources :settlements

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
  get '/people/random-name' => 'people#random_name'
  resources :people, :controller => 'beings',  :_type => 'Person'
  # beings
  resources :beings do
    resources :things
  end

  get 'histogram/corpus/load' => 'histogram#load_corpus'
  get 'languages/corpus/load' => 'histogram#load_corpus'

end
