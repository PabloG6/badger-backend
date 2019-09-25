defmodule BadgerApiWeb.RelationshipsController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Relationships

  action_fallback BadgerApiWeb.FallbackController

  def followers(conn, _params) do
    writer = Guardian.Plug.current_resource(conn)
    followers = Accounts.followers(writer.id)
    render(conn, "followers.json", followers: followers)
  end

  def following(conn, _params) do
    writer = Guardian.Plug.current_resource(conn)
    following = Accounts.following(writer.id)
    conn
    |> put_status(:created)
    |> render("subjects.json", subjects: following)
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





  def delete(conn, %{"id" => unfollow_id}) do
    writer = Guardian.Plug.current_resource(conn)
    with {:ok, _} <- Accounts.unfollow(writer.id, unfollow_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
