Terribletracker::Application.routes.draw do
  root to: "projects#index"

  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
    get "/logout" => "devise/sessions#destroy"
  end

  resources :projects do
    resources :user_stories
  end

  resources :memberships

  resources :teams

  post "/show_projects", to: "teams#show_projects"
  post "/show_project", to: "teams#show_project"

  get "user_story/:id/unstarted", to: "user_stories#unstarted"
  get "user_story/:id/started", to: "user_stories#started"
  get "user_story/:id/review", to: "user_stories#review"
  get "user_story/:id/finished", to: "user_stories#finished"
  get "user_story/:user_story_id/assign/:id", to: "user_stories#assign"
  post "sort/user_stories", to: "user_stories#sort"

  get "/membership/:id/accept", to: "memberships#accept"
  get "/membership/:id/decline", to: "memberships#decline"
  get "/membership/:id/accept_team", to: "memberships#accept_team"
  delete "/membership/:id/remove_team", to: "memberships#remove_team"
  get "/new/team_membership", to: "memberships#new_team_membership"
  post "/create_team_membership", to: "memberships#create_team_membership"
  get "/add_project_to_team", to: "projects#add_project_to_team"
  put "/save_team_project_join", to: "projects#save_team_project_join"

end
