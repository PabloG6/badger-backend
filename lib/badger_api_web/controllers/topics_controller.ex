defmodule BadgerApiWeb.TopicsController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Badge
  alias BadgerApi.Badge.Topics

  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    topics = Badge.list_topics()
    render(conn, "index.json", topics: topics)
  end



  def create(conn, %{"topics" => topics_params}) do
    with {:ok, %Topics{} = topics} <- Badge.create_topics(topics_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.topics_path(conn, :show, topics))
      |> render("show.json", topics: topics)
    end
  end

  def show(conn, %{"id" => id}) do
    topics = Badge.get_topics!(id)
    render(conn, "show.json", topics: topics)
  end

  def update(conn, %{"id" => id, "topics" => topics_params}) do
    topics = Badge.get_topics!(id)

    with {:ok, %Topics{} = topics} <- Badge.update_topics(topics, topics_params) do
      render(conn, "show.json", topics: topics)
    end
  end

  def delete(conn, %{"id" => id}) do
    topics = Badge.get_topics!(id)

    with {:ok, %Topics{}} <- Badge.delete_topics(topics) do
      send_resp(conn, :no_content, "")
    end
  end
end
