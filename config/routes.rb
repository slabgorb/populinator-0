Population::Application.routes.draw do
  resources :damages
  resources :beings do
    resources :things
  end
  resources :things
end
