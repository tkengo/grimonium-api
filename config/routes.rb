Rails.application.routes.draw do
  root to: 'root#index'

  scope '/api/:version', module: :api, defaults: { format: :json }, constraints: { version: /(v1)/ } do
    resources :urls, only: [ :index, :create ] do
      resources :crawls, only: [ :create ], module: :urls
      resources :queues, only: [ :create ], module: :urls
    end
  end
end
