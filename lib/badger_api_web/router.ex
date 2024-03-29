defmodule BadgerApiWeb.Router do
  use BadgerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug BadgerApi.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api, :auth]
    resources "/topics", TopicsController, except: [:new, :edit], param: "slug"
    resources "/writers", WritersController, except: [:new, :edit, :show, :index, :create]
    resources "/articles", ArticlesController, except: [:new, :edit]
    post "/follow", RelationshipsController, :create
    delete "/unfollow/:id", RelationshipsController, :delete
    get "/followers", RelationshipsController, :followers
    get "/following", RelationshipsController, :following
    get "/following/show/:id", RelationshipsController, :show
    get "/feed", ArticlesController, :list_feed_articles
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api, :auth]
    get "/topics/:slug/articles", TopicsController, :filter_articles
    post "/topics/:slug/follow", TopicsController, :follow_topics
    delete "/topics/:slug/unfollow", TopicsController, :unfollow_topics
    get "/topics/subscriptions/following", TopicsController, :following
    get "/topics/is-following/:slug", TopicsController, :is_following?
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api]
    post "/login", WritersController, :login
    post "/signup", WritersController, :signup
    get "/writers/:id", WritersController, :show
    post "/writers", WritersController, :create
    get "/writers", WritersController, :index
  end
end
