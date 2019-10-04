defmodule BadgerApiWeb.ArticlesController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Articles

  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    articles = Publications.list_articles()
    render(conn, "index.json", articles: articles)
  end
  defp build_association(writer, attrs) do
    Map.put(attrs, "writer_id", writer.id)
  end
  def create(conn, %{"articles" => articles_params}) do

    story = Guardian.Plug.current_resource(conn)
    |> build_association(articles_params)



    with {:ok, %Articles{} = articles} <- Publications.create_articles(story) do
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
      render(conn, "show.json", articles: articles)
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
    articles = Publications.get_articles!(id)

    with true <- writer.id == articles.writer_id,
    {:ok, %Articles{}} <- Publications.delete_articles(articles) do
      send_resp(conn, :no_content, "")
    else
      false -> {:error, :unauthorized_delete_story}
      {:error, changeset} -> {:error, changeset}
      error -> error
    end
  end
end
