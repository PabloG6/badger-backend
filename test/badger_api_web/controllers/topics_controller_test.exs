defmodule BadgerApiWeb.TopicsControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Badge
  alias BadgerApi.Badge.Topics

  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{title: nil, description: nil}

  def fixture(:topics) do
    {:ok, topics} = Badge.create_topics(@create_attrs)
    topics
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all topics", %{conn: conn} do
      conn = get(conn, Routes.topics_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create topics" do
    test "renders topics when data is valid", %{conn: conn} do
      conn = post(conn, Routes.topics_path(conn, :create), topics: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.topics_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "title" => "some-title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.topics_path(conn, :create), topics: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update topics" do
    setup [:create_topics]

    test "renders topics when data is valid", %{conn: conn, topics: %Topics{id: id} = topics} do
      conn = put(conn, Routes.topics_path(conn, :update, topics), topics: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.topics_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, topics: topics} do
      conn = put(conn, Routes.topics_path(conn, :update, topics), topics: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete topics" do
    setup [:create_topics]

    test "deletes chosen topics", %{conn: conn, topics: topics} do
      conn = delete(conn, Routes.topics_path(conn, :delete, topics))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.topics_path(conn, :show, topics))
      end
    end
  end

  defp create_topics(_) do
    topics = fixture(:topics)
    {:ok, topics: topics}
  end
end
