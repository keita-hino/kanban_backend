Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace 'api' do
    namespace 'v1' do
      resources :tasks, only: [:index, :create] do
        collection do
          patch :update
          patch :moved_tasks
          patch :update_status_task
        end
      end
    end
  end
end
