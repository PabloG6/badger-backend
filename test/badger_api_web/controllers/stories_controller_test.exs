defmodule BadgerApiWeb.ArticlesControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Writer
  @create_attrs %{
    content: "some content",
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
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


  @invalid_attrs %{content: nil, description: nil, title: nil}

  defp create_valid_attrs(writer, attrs) do
    Map.put(attrs, :writer_id, writer.id)
  end

  def fixture(%Writer{} = writer, :articles) do

    {:ok, articles} = Publications.create_articles(create_valid_attrs(writer, @create_attrs))
    articles
  end

  setup %{conn: conn} do
    {:ok, writer} = Accounts.create_writer(@create_writer_attrs)
    {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writer)
     conn = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, writer: writer}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.articles_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end


  describe "create articles" do
    test "renders articles when data is valid", %{conn: conn} do
      conn = post(conn, Routes.articles_path(conn, :create), articles:  @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.articles_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some content",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, } do
      conn = post(conn, Routes.articles_path(conn, :create), articles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end



  end

  describe "update articles" do
    setup [:create_articles]

    test "renders articles when data is valid", %{conn: conn, articles: %Articles{id: id} = articles} do

      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.articles_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some updated content",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, articles: articles} do
      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when a different user is logged in",%{conn: conn, articles: articles} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      {:ok, token, _} = writer |> BadgerApi.Auth.Guardian.encode_and_sign
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @update_attrs)

      assert %{"detail" =>
      "You're not authorized to update this post"} = json_response(conn, 401)["errors"]
    end
  end

  describe "delete articles" do
    setup [:create_articles]

    test "deletes chosen articles", %{conn: conn, articles: articles} do
      conn = delete(conn, Routes.articles_path(conn, :delete, articles))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.articles_path(conn, :show, articles))
      end
    end

    test "delete story when a different user is logged in",%{conn: conn, articles: articles} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      {:ok, token, _} = writer |> BadgerApi.Auth.Guardian.encode_and_sign
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @update_attrs)

      assert response(conn, 401)

    end
  end

  defp create_articles(%{writer: writer}) do

    articles = fixture(writer, :articles)
    {:ok, articles: articles}
  end
end
