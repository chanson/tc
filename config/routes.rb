Tc::Application.routes.draw do
  authenticated :user do
    root :to => 'home#authed'
  end
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :tasks do
    post 'complete_task'
  end

  resources :projects

  resources :groups

  resources :invites, :only => [:create, :destroy, :new]
end