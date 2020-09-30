Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :interviews
  
  namespace 'api' do
    namespace 'v1' do
      resources :interviews
    end
  end

  get 'users/1/new', to: 'users#new_interviewer'
  get 'users/0/new', to: 'users#new_candidate'
  post 'users', to: 'users#create'
  # post 'users', to: 'users#create_candidate'
  root 'interviews#index'
end
