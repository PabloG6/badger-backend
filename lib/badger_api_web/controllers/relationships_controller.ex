defmodule BadgerApiWeb.RelationshipsController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Relationships

  action_fallback BadgerApiWeb.FallbackController

  def followers(conn, params \\ %{}) do
    writer = Guardian.Plug.current_resource(conn)
    page = Accounts.followers(writer.id, params)

    render(
      conn,
      :followers,
      followers: page.entries,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      page_number: page.page_number,
      page_size: page.page_size
    )
  end

  def following(conn, params \\ %{}) do
    writer = Guardian.Plug.current_resource(conn)
    page = Accounts.following(writer.id, params)

    conn
    |> put_status(:created)
    |> render(:following,
      subjects: page.entries,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      page_size: page.page_size,
      page_number: page.page_number
    )
  end

  def create(conn, %{"subject_id" => subject_id}) do
    writer = Guardian.Plug.current_resource(conn)

    with {:ok, %Relationships{} = relationships} <- Accounts.follow(writer.id, subject_id) do
      conn
      |> put_status(:created)
      |> render("show.json", relationships: relationships)
    end
  end

  def show(conn, %{"id" => id}) do
    writer = Guardian.Plug.current_resource(conn)

    with %Relationships{} = relationships <- Accounts.is_following?(writer.id, id) do
      conn
      |> put_status(:ok)
      |> render("show.json", relationships: relationships)
    end
  end

  def delete(conn, %{"subject_id" => unfollow_id}) do
    writer = Guardian.Plug.current_resource(conn)

    with {:ok, _} <- Accounts.unfollow(writer.id, unfollow_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
