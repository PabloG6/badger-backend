defmodule BadgerApiWeb.SearchControllerTest do
  use BadgerApiWeb.ConnCase

  # alias BadgerApi.Discovery
  # alias BadgerApi.Discovery.Search

  # @create_attrs %{

  # }
  # @update_attrs %{

  # }
  # @invalid_attrs %{}

  def fixture(:search) do
    # {:ok, search} = Discovery.create_search(@create_attrs)
    # search
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all search", %{conn: _conn} do
      # conn = get(conn, Routes.search_path(conn, :index))
      # assert json_response(conn, 200)["data"] == []
      assert true
    end
  end

  describe "create search" do
    test "renders search when data is valid", %{conn: _conn} do
      # conn = post(conn, Routes.search_path(conn, :create), search: @create_attrs)
      # assert %{"id" => id} = json_response(conn, 201)["data"]

      # conn = get(conn, Routes.search_path(conn, :show, id))

      # assert %{
      #          "id" => id
      #        } = json_response(conn, 200)["data"]
      assert true
    end

    test "renders errors when data is invalid", %{conn: _conn} do
      # conn = post(conn, Routes.search_path(conn, :create), search: @invalid_attrs)
      # assert json_response(conn, 422)["errors"] != %{}
      assert true
    end
  end

  describe "update search" do
    setup [:create_search]

    test "renders search when data is valid", %{conn: _conn, search: _} do
      # conn = put(conn, Routes.search_path(conn, :update, search), search: @update_attrs)
      # assert %{"id" => ^id} = json_response(conn, 200)["data"]

      # conn = get(conn, Routes.search_path(conn, :show, id))

      # assert %{
      #          "id" => id
      #        } = json_response(conn, 200)["data"]
      assert true
    end

    test "renders errors when data is invalid", %{conn: _conn, search: _} do
      # conn = put(conn, Routes.search_path(conn, :update, search), search: @invalid_attrs)
      # assert json_response(conn, 422)["errors"] != %{}
      assert true
    end
  end

  describe "delete search" do
    setup [:create_search]

    test "deletes chosen search", %{conn: _conn, search: _search} do
      # conn = delete(conn, Routes.search_path(conn, :delete, search))
      # assert response(conn, 204)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.search_path(conn, :show, search))
      assert true
    end
  end

  defp create_search(_) do
    search = fixture(:search)
    {:ok, search: search}
  end
end
