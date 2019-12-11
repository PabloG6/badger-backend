defmodule BadgerApiWeb.Router do
  use BadgerApiWeb, :router

  pipeline :api do
    plug Corsica,
      origins: "*",
      allow_headers: :all,
      allow_methods: :all,
      allow_credentials: true

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
    delete "/unfollow/:subject_id", RelationshipsController, :delete
    get "/followers", RelationshipsController, :followers
    get "/following", RelationshipsController, :following
    get "/following/show/:id", RelationshipsController, :show
    get "/feed", ArticlesController, :list_feed_articles
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api, :auth]
    get "/topics/:slug/articles", TopicsController, :filter_articles
    post "/topics/:slug/follow", TopicsController, :follow_topics

    delete "/topics/:slug/follow", TopicsController, :unfollow_topics
    get "/topics/subscriptions/following", TopicsController, :following
    get "/topics/is-following/:slug", TopicsController, :is_following?
    get "/topics/filter/popularity", TopicsController, :index_by_popularity
  end

  scope "/api", BadgerApiWeb do
    resources "/query", SearchController, except: [:new, :edit]
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api]
    get "/writers/interests", WritersController, :list_writers_by_interest
    get "/writers/popularity/topics", WritersController, :topics_popularity
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
