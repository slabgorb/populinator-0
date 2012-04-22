Population::Application.routes.draw do
  resources :events

  resources :settlements
  resources :damages
  resources :beings do
    resources :things
  end
  resources :things 
  resources :people, :controller => 'beings',  :type => 'Person'
  resources :ruler, :controller => 'beings',  :type => 'Ruler'
  match '/simulation/run' => 'simulations#run'

end
