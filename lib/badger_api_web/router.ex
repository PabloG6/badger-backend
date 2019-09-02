defmodule BadgerApiWeb.Router do
  use BadgerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BadgerApiWeb do
    pipe_through :api

    resources "/topics", TopicsController, except: [:new, :edit]
    get "/topics/all", TopicsController, :index

  end
end
