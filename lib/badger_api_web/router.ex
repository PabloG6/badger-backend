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
    resources "/topics", TopicsController, except: [:new, :edit]
    resources "/writers", WritersController, except: [:new, :edit, :create, :show, :index]
    resources "/stories", StoriesController, except: [:new, :edit]
  end

  scope "/api", BadgerApiWeb do
    pipe_through [:api]
    post "/login", WritersController, :login
    post "/signup", WritersController, :create
    get "/writers/:id", WritersController, :show
    get "/writers", WritersController, :index

  end
end
