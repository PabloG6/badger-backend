defmodule BadgerApiWeb.ArticlesController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Articles
  action_fallback BadgerApiWeb.FallbackController

  def index(conn, params) do
    page = Publications.list_articles(params)

    render(conn, :index,
      articles: page.entries,
      total_entries: page.total_entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages
    )
  end

  defp build_association(writer, attrs) do
    Map.put(attrs, "writer_id", writer.id)
  end

  def create(conn, %{"articles" => params}) do
    article_assoc =
      Guardian.Plug.current_resource(conn)
      |> build_association(params)

    with {:ok, %Articles{} = articles} <- Publications.create_articles(article_assoc) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.articles_path(conn, :show, articles))
      |> render("show.json", articles: articles)
    end
  end

  def show(conn, %{"id" => id}) do
    articles = Publications.get_articles!(id)
    render(conn, "show.json", articles: articles)
  end

  def update(conn, %{"id" => id, "articles" => articles_params}) do
    writer = Guardian.Plug.current_resource(conn)

    articles = Publications.get_articles!(id)

    with true <- writer.id == articles.writer_id,
         {:ok, %Articles{} = articles} <- Publications.update_articles(articles, articles_params) do
      render(conn, :show, articles: articles)
    else
      false ->
        {:error, :unauthorized_update_story}

      {:error, changeset} ->
        {:error, changeset}

      error ->
        error
    end
  end

  def delete(conn, %{"id" => id}) do
    writer = Guardian.Plug.current_resource(conn)
    articles = Publications.get_articles!(id)

    with true <- writer.id == articles.writer_id,
         {:ok, %Articles{}} <- Publications.delete_articles(articles) do
      # Exsolr.delete_by_id(articles.id)
      send_resp(conn, :no_content, "")
    else
      false -> {:error, :unauthorized_delete_story}
      {:error, changeset} -> {:error, changeset}
      error -> error
    end
  end

  def list_feed_articles(conn, params) do
    writer = Guardian.Plug.current_resource(conn)
    page = Publications.list_feed_articles(writer.id, params)

    conn
    |> put_status(:ok)
    |> render(:index,
      articles: page.entries,
      total_entries: page.total_entries,
      page_size: page.page_size,
      total_pages: page.total_pages
    )
  end
end
