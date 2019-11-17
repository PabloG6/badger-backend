defmodule BadgerApiWeb.SearchController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Discovery

  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    search = Discovery.list_search()
    render(conn, "index.json", search: search)
  end

  def create(conn, %{"search" => search_params}) do
    with {:ok, search} <- Discovery.create_search(search_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.search_path(conn, :show, search))
      |> render("show.json", search: search)
    end
  end

  def show(conn, %{"id" => id}) do
    search = Discovery.get_search!(id)
    render(conn, "show.json", search: search)
  end

  def update(conn, %{"id" => id, "search" => search_params}) do
    search = Discovery.get_search!(id)

    with {:ok, search} <- Discovery.update_search(search, search_params) do
      render(conn, "show.json", search: search)
    end
  end

  def delete(conn, %{"id" => id}) do
    search = Discovery.get_search!(id)

    with {:ok, _} <- Discovery.delete_search(search) do
      send_resp(conn, :no_content, "")
    end
  end
end
