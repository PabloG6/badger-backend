defmodule BadgerApiWeb.RelationshipsControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Accounts

  alias BadgerApi.Accounts.Relationships

  @follower %{
    username: "@follower",
    password: "password",
    email: "follower@badger.com",
    name: "some follower"
  }

  @subject %{
    username: "@following",
    password: "password",
    email: "following@badger.com",
    name: "Some Subject"
  }

  setup %{conn: conn} do
    {:ok, writer} = Accounts.create_writer(@follower)
    {:ok, token, _claims} = BadgerApi.Auth.Guardian.encode_and_sign(writer)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, writer: writer}
  end

  def fixture(:subject) do
    {:ok, subject} = Accounts.create_writer(@subject)
    subject
  end

  describe "index" do
    setup [:create_follower]

    test "lists all followers", %{conn: conn, subject: subject} do
      conn = get(conn, Routes.relationships_path(conn, :followers))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => subject.id,
                 "username" => subject.username,
                 "name" => subject.name
               }
             ]
    end
  end

  describe "following" do
    setup [:create_following]

    test "list all following", %{conn: conn, subject: subject} do
      conn = get(conn, Routes.relationships_path(conn, :following))

      assert json_response(conn, 201)["data"] == [
               %{
                 "id" => subject.id,
                 "username" => subject.username,
                 "name" => subject.name
               }
             ]
    end
  end

  describe "follow user" do
    setup [:create_subject]

    test "follow a user", %{conn: conn, subject: subject} do
      conn = post(conn, Routes.relationships_path(conn, :create), subject_id: subject.id)
      assert %{"id" => id, "following_id" => following_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.relationships_path(conn, :show, following_id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end
  end

  describe "unfollow user" do
    setup [:create_following]

    test "check if following user", %{
      conn: conn,
      subject: subject,
      writer: writer,
      relationships: %Relationships{id: id}
    } do
      conn = get(conn, Routes.relationships_path(conn, :show, subject.id))

      assert %{"following_id" => subject.id, "follower_id" => writer.id, "id" => id} ==
               json_response(conn, 200)["data"]
    end

    test "unfollow said user", %{conn: conn, subject: subject} do
      conn = delete(conn, Routes.relationships_path(conn, :delete, subject.id))
      assert response(conn, 204)
    end
  end

  defp create_follower(%{writer: writer}) do
    subject = fixture(:subject)
    {:ok, relationship} = Accounts.follow(subject.id, writer.id)
    {:ok, relationships: relationship, subject: subject}
  end

  defp create_following(%{writer: writer}) do
    subject = fixture(:subject)
    {:ok, relationship} = Accounts.follow(writer.id, subject.id)
    {:ok, relationships: relationship, subject: subject}
  end

  defp create_subject(_) do
    subject = fixture(:subject)
    {:ok, subject: subject}
  end
end
