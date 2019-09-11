defmodule BadgerApiWeb.StoriesController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Stories

  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    stories = Publications.list_stories()
    render(conn, "index.json", stories: stories)
  end

  def create(conn, %{"stories" => stories_params}) do
    with {:ok, %Stories{} = stories} <- Publications.create_stories(stories_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.stories_path(conn, :show, stories))
      |> render("show.json", stories: stories)
    end
  end

  def show(conn, %{"id" => id}) do
    stories = Publications.get_stories!(id)
    render(conn, "show.json", stories: stories)
  end

  def update(conn, %{"id" => id, "stories" => stories_params}) do
    stories = Publications.get_stories!(id)

    with {:ok, %Stories{} = stories} <- Publications.update_stories(stories, stories_params) do
      render(conn, "show.json", stories: stories)
    end
  end

  def delete(conn, %{"id" => id}) do
    stories = Publications.get_stories!(id)

    with {:ok, %Stories{}} <- Publications.delete_stories(stories) do
      send_resp(conn, :no_content, "")
    end
  end
end
