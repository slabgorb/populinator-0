Population::Application.routes.draw do

  match '/' => 'index#homepage'

  resources :things
  resources :damages
  resources :events
  resources :languages
  resources :settlements
  resources :corpora

  # settlements
  get '/settlement/random' => 'settlements#create', random: true, as: :random_settlement
  get '/settlement/advanced' => 'settlements#new', advanced: true, as: :advanced_settlement
  put '/settlement/seed/:id' => 'settlements#seed', as: :seed
  get '/random/name/settlement/(:language)' => 'settlements#random_name'
  get '/random/name/given/(:language)' => 'beings#random_name'
  get '/icon-list' => 'index#icon_list'


  get '/beings/graph' => 'beings#graph'
  put '/beings/kill/:id' => 'beings#kill', as: :kill
  put '/beings/resurrect/:id' => 'beings#resurrect', as: :resurrect
  put '/beings/age/:id' => 'beings#age', as: :age
  match '/beings/reproduce/:parent_a/:parent_b' => 'beings#reproduce', as: :reproduction
  get '/beings/:id/genotype/' => 'beings#genotype'
  match '/beings/:id/genotype/random' => 'beings#randomize_genetics', as: :random_genotype
  get '/beings/family/:id' => 'beings#family'
  get '/beings/description/:id' => 'beings#description'
  get '/beings/history/:id' => 'beings#history'
  get '/beings/name/random' => 'people#random_name'
  get '/people/random-name' => 'people#random_name'
  resources :people, :controller => 'beings',  _type:'Person'
  # beings
  resources :beings do
    resources :things
  end

  get 'histogram/corpus/load' => 'histogram#load_corpus'
  get 'languages/corpus/load' => 'histogram#load_corpus'

end
