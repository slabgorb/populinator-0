Population::Application.routes.draw do
  resources :settlements
  resources :damages
  resources :beings do
    resources :things
  end
  resources :things 
  
  match '/simulation/run' => 'simulations#run'

end
