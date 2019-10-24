defmodule BadgerApiWeb.TopicsController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Badge
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Context.InterestedinTopics
  alias BadgerApi.Context
  action_fallback BadgerApiWeb.FallbackController

  def index(conn, params) do
    page = Badge.list_topics(params)

    render(conn, "index.json",
      topics: page.entries,
      total_pages: page.total_pages,
      page_size: page.page_size,
      page_number: page.page_number,
      total_entries: page.total_entries
    )
  end

  def create(conn, %{"topics" => topics_params}) do
    with {:ok, %Topics{} = topics} <- Badge.create_topics(topics_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.topics_path(conn, :show, topics))
      |> render("show.json", topics: topics)
    end
  end

  def filter_articles(conn, %{"slug" => slug}) do
    page = Badge.filter_articles!(slug)

    render(conn, "show_articles.json",
      articles: page.entries,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      page_number: page.page_number,
      page_size: page.page_size
    )
  end

  def follow_topics(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug!(slug)

    with {:ok, %InterestedinTopics{}} <-
           Context.create_topics_interest(%{writer_id: writer.id, topics_id: topics.id}) do
      send_resp(conn, :created, "")
    end
  end

  def unfollow_topics(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug!(slug)
    topics_interest = Context.get_specific_topics_interest!(writer.id, topics.id)

    with {:ok, %InterestedinTopics{}} <- Context.delete_topics_interest(topics_interest) do
      send_resp(conn, :no_content, "")
    end
  end

  def following(conn, params) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Context.list_topics_interest(writer.id, params)
    render(conn, :index, topics: topics)
  end

  def is_following?(conn, %{"slug" => slug}) do
    writer = Guardian.Plug.current_resource(conn)
    topics = Badge.get_topics_by_slug(slug)

    case Context.is_following?(writer.id, topics.id) do
      true -> send_resp(conn, :no_content, "")
      false -> {:error, :not_found}
      _ -> {:error, :not_found}
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
