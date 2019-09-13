defmodule BadgerApiWeb.StoriesController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Stories

  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    stories = Publications.list_stories()
    render(conn, "index.json", stories: stories)
  end
  defp build_association(writer, attrs) do
    Map.put(attrs, "writer_id", writer.id)
  end
  def create(conn, %{"stories" => stories_params}) do

    story = Guardian.Plug.current_resource(conn)
    |> build_association(stories_params)



    with {:ok, %Stories{} = stories} <- Publications.create_stories(story) do
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
    writer = Guardian.Plug.current_resource(conn)

    stories = Publications.get_stories!(id)
    IO.puts writer.id
    IO.puts stories.writer_id


    with true <- writer.id == stories.writer_id,
    {:ok, %Stories{} = stories} <- Publications.update_stories(stories, stories_params) do
      render(conn, "show.json", stories: stories)
    else
      false ->
        {:error, :unauthorized_update_story}

      {:error, changeset} -> {:error, changeset}
      error ->
        error
    end
  end

  def delete(conn, %{"id" => id}) do
    writer = Guardian.Plug.current_resource(conn)
    stories = Publications.get_stories!(id)

    with true <- writer.id == stories.writer_id,
    {:ok, %Stories{}} <- Publications.delete_stories(stories) do
      send_resp(conn, :no_content, "")
    else
      false -> {:error, :unauthorized_delete_story}
      {:error, changeset} -> {:error, changeset}
      error -> error
    end
  end
end
