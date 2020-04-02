Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:index]
      resources :tasks, only: [:index]
    end
  end
end
