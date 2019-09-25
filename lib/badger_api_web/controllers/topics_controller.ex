defmodule BadgerApiWeb.TopicsController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Badge
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Context.TopicsInterest
  alias BadgerApi.Context
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





  def filter_stories(conn, %{"slug" => slug}) do
    stories = Badge.filter_stories!(slug)
    render(conn, "show_stories.json", stories: stories)
  end

  def follow_topics(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug!(slug)
    with {:ok, %TopicsInterest{}} <- Context.create_topics_interest(%{writer_id: writer.id, topics_id: topics.id}) do
      send_resp(conn, :created, "")

    end

  end

  def unfollow_topics(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug!(slug)
    with {:ok, %TopicsInterest{}} <- Context.delete_topics_interest(%{writer_id: writer.id, topics_id: topics.id}) do
      send_resp(conn, :no_content, "")
    end


  end


  def following(conn, _params) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Context.list_topics_interest(writer.id)
    render(conn, :index, topics: topics)
  end

  def is_following(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug(slug)
    with true <- Context.is_following?(writer.id, topics.id) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, %{"slug" => slug}) do
    topics = Badge.get_topics_by_slug!(slug)
    render(conn, "show.json", topics: topics)

  end


  def update(conn, %{"slug" => slug, "topics" => topics_params}) do
    topics = Badge.get_topics_by_slug!(slug)

    with {:ok, %Topics{} = topics} <- Badge.update_topics(topics, topics_params) do
      render(conn, "show.json", topics: topics)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    topics = Badge.get_topics_by_slug!(slug)

    with {:ok, %Topics{}} <- Badge.delete_topics(topics) do
      send_resp(conn, :no_content, "")
    end
  end


end
