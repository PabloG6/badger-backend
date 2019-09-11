defmodule BadgerApiWeb.WritersControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Writer

  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password_hash",
    username: "@someusername"
  }
  @update_attrs %{
    email: "someupdated@email.com",
    name: "some updated name",
    password: "some updated password_hash",
    username: "@someupdatedusername"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil, username: nil}

  defp fixture(:writers) do
    {:ok, writer} = Accounts.create_writer(@create_attrs)
    writer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
  end
  describe "test sign in for writers" do
    setup [:create_writers]
    test "renders sign in page when writer uses their username ", %{conn: conn, writers: %Writer{id: id} = writers} do
      conn = post(conn, Routes.writers_path(conn, :login), identifier: writers.username, password: writers.password)
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
      conn = put(conn, Routes.writers_path(conn, :update, writers), writers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete writers" do
    setup [:create_writers]

    test "deletes chosen writers", %{conn: conn, writers: writers} do
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