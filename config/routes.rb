Terribletracker::Application.routes.draw do
  resources :activities


  root to: "projects#index"

  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
    get "/logout" => "devise/sessions#destroy"
  end

  resources :projects do
    resources :comments
    resources :user_stories do
      resources :comments
    end
  end

  resources :memberships

  resources :teams

  post "/teams/:id", to: "teams#show"
  post "/show_project", to: "teams#show_project"
  get "/homepage", to: "projects#homepage"

  get "user_story/:id/unstarted", to: "user_stories#unstarted"
  get "user_story/:id/started", to: "user_stories#started"
  get "user_story/:id/review", to: "user_stories#review"
  get "user_story/:id/finished", to: "user_stories#finished"
  get "user_story/:user_story_id/assign/:id", to: "user_stories#assign"
  post "sort/user_stories", to: "user_stories#sort"
  get "user_story/:id/show", to: "user_stories#show"

  get "/membership/:id/accept", to: "memberships#accept"
  get "/membership/:id/decline", to: "memberships#decline"
  get "/new/team_membership", to: "memberships#new_team_membership"
  post "/create", to: "memberships#create"
  get "/add_project_to_team", to: "projects#add_project_to_team"
  put "/save_team_project_join", to: "projects#save_team_project_join"

  post "user_story/:id/comments/create", to: "comments#create"

end
