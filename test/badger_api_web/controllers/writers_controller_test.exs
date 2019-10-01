defmodule BadgerApiWeb.WritersControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Writer



  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password_hash",
    username: "@someusername",
    writes_about_topics: ["dragon fruit", "entawak", "figs"]
  }




  @update_attrs %{
    email: "someupdated@email.com",
    name: "some updated name",
    password: "some updated password_hash",
    username: "@someupdatedusername",
    writes_about_topics: ["apples", "bananas", "coconut"]
  }
  @invalid_attrs %{email: nil, name: nil, password: nil, username: nil}

  defp fixture(:writers) do
    {:ok, writer} = Accounts.create_writer(@create_attrs)
    writer
  end

  setup %{conn: conn} do

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp put_profile_image(attrs \\ %{}) do

    attrs |> Map.put("avatar",
     %Plug.Upload{filename: "profile-pic.jpg", path: "test/static/", content_type: "image/jpeg"})
  end
  describe "index" do

    test "lists all writer", %{conn: conn} do


      conn = get(conn, Routes.writers_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create writers" do
    test "renders writers when data is valid", %{conn: conn} do

      conn = post(conn, Routes.writers_path(conn, :create), writers: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.writers_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some@email.com",
               "name" => "some name",
               "username" => "@someusername"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.writers_path(conn, :create), writers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders data when profile image is sent" , %{conn: conn} do
      conn = post(conn, Routes.writers_path(conn, :create), writers: put_profile_image(@create_attrs))
    end
  end
  describe "account session for writers" do
    setup [:create_writers]
    test "renders sign in page when writer uses their username ", %{conn: conn, writers: %Writer{id: id} = writers} do


      conn = post(conn, Routes.writers_path(conn, :login), identifier: writers.username, password: writers.password)
      assert %{"id" => ^id,
                "email" => "some@email.com",
                "name" => "some name",
                "username" => "@someusername",
              } = json_response(conn, 200)["data"]
    end

    test "renders sign in page when writers uses their email", %{conn: conn, writers: %Writer{id: id} = writers} do
      conn = post(conn, Routes.writers_path(conn, :login), identifier: writers.email, password: writers.password)
      assert %{"id" => ^id,
                "email" => "some@email.com",
                "name" => "some name",
                "username" => "@someusername",
              } = json_response(conn, 200)["data"]

    end
  end



  describe "update writers" do
    setup [:create_writers]

    test "renders writers when data is valid", %{conn: conn, writers: %Writer{id: id} = writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.writers_path(conn, :update, writers), writers: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.writers_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "someupdated@email.com",
               "name" => "some updated name",
               "username" => "@someupdatedusername"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, writers: writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.writers_path(conn, :update, writers), writers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete writers" do
    setup [:create_writers]

    test "deletes chosen writers", %{conn: conn, writers: writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = delete(conn, Routes.writers_path(conn, :delete, writers))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.writers_path(conn, :show, writers))
      end
    end
  end

  defp create_writers(_) do
    writers = fixture(:writers)
    {:ok, writers: writers}
  end
end
