Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:index]
      resources :tasks, only: [:index] do
        collection do
          patch :moved_tasks
          patch :update_status_task
        end
      end
    end
  end
end
