Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        # registrations: 'api/v1/auth/registrations',
        sessions: 'api/v1/auth/sessions',
        # passwords: 'api/v1/auth/passwords',
        # unlocks: 'api/v1/auth/unlocks'
      }
      # ユーザー
      resources :users, only: [] do
        collection do
          patch :update
        end
      end

      # タスク
      resources :tasks, only: [:index, :create] do
        collection do
          patch :update
          patch :moved_tasks
          patch :update_status_task
        end
      end

      # ワークスペース
      resources :workspaces, only: [:index]

    end
  end
end
