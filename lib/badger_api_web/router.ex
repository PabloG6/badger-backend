defmodule BadgerApiWeb.Router do
  use BadgerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", BadgerApiWeb do
    pipe_through :api
    resources "/topics", TopicsController, except: [:new, :edit]
    resources "/writers", WritersController, except: [:new, :edit]
    post "/login", WritersController, :login
    resources "/stories", StoriesController, except: [:new, :edit]

  end
end
