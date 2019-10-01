defmodule BadgerApiWeb.StoriesControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Stories
  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Writer
  @create_attrs %{
    body: "some body",
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    description: "some updated description",
    title: "some updated title"
  }

  @create_writer_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password_hash",
    username: "@someusername"
  }

  @updated_writer_attrs %{
    email: "updated@email.com",
    name: "updated name",
    password: "some password_hash",
    username: "@updatedusername",
  }


  @invalid_attrs %{body: nil, description: nil, title: nil}

  defp create_valid_attrs(writer, attrs) do
    Map.put(attrs, :writer_id, writer.id)
  end

  def fixture(%Writer{} = writer, :stories) do

    {:ok, stories} = Publications.create_stories(create_valid_attrs(writer, @create_attrs))
    stories
  end

  setup %{conn: conn} do
    {:ok, writer} = Accounts.create_writer(@create_writer_attrs)
    {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writer)
     conn = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, writer: writer}
  end

  describe "index" do
    test "lists all stories", %{conn: conn} do
      conn = get(conn, Routes.stories_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end


  describe "create stories" do
    test "renders stories when data is valid", %{conn: conn} do
      conn = post(conn, Routes.stories_path(conn, :create), stories:  @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.stories_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, } do
      conn = post(conn, Routes.stories_path(conn, :create), stories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end



  end

  describe "update stories" do
    setup [:create_stories]

    test "renders stories when data is valid", %{conn: conn, stories: %Stories{id: id} = stories} do

      conn = put(conn, Routes.stories_path(conn, :update, stories), stories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.stories_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, stories: stories} do
      conn = put(conn, Routes.stories_path(conn, :update, stories), stories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when a different user is logged in",%{conn: conn, stories: stories} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      {:ok, token, _} = writer |> BadgerApi.Auth.Guardian.encode_and_sign
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.stories_path(conn, :update, stories), stories: @update_attrs)

      assert %{"detail" =>
      "You're not authorized to update this post"} = json_response(conn, 401)["errors"]
    end
  end

  describe "delete stories" do
    setup [:create_stories]

    test "deletes chosen stories", %{conn: conn, stories: stories} do
      conn = delete(conn, Routes.stories_path(conn, :delete, stories))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.stories_path(conn, :show, stories))
      end
    end

    test "delete story when a different user is logged in",%{conn: conn, stories: stories} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      {:ok, token, _} = writer |> BadgerApi.Auth.Guardian.encode_and_sign
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.stories_path(conn, :update, stories), stories: @update_attrs)

      assert response(conn, 401)

    end
  end

  defp create_stories(%{writer: writer}) do

    stories = fixture(writer, :stories)
    {:ok, stories: stories}
  end
end
