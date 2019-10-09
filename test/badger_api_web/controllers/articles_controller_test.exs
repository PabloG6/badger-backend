defmodule BadgerApiWeb.ArticlesControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Publications
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Accounts

  alias BadgerApi.Badge
  alias BadgerApi.Context
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

  @second_writer_attrs %{
    email: "second@email.com",
    name: "second name",
    password: "some password_hash",
    username: "@secondusername"
  }

  @third_writer_attrs %{
    email: "third@email.com",
    name: "third name",
    password: "third password hash",
    username: "@thirdname"
  }

  @fourth_writer_attrs %{
    email: "fourth@email.com",
    name: "fourth name",
    password: "third password hash",
    username: "@fourthname"
  }

  @updated_writer_attrs %{
    email: "updated@email.com",
    name: "updated name",
    password: "some password_hash",
    username: "@updatedusername"
  }

  @create_topics_attrs %{title: "Fourth Topic"}
  @first_story_attrs %{
    content: "first article content",
    title: "first article title",
    description: "first article description"
  }
  @second_story_attrs %{
    content: "second article content",
    title: "second article title",
    description: "second article description"
  }
  @third_story_attrs %{
    content: "third article content",
    title: "third article title",
    description: "third article description"
  }
  @fourth_story_attrs %{
    content: "fourth article content",
    title: "fourth article title",
    description: "fourth article description",
    categories: ["Fourth Topic"]
  }

  @invalid_attrs %{content: nil, description: nil, title: nil}

  defp create_valid_attrs(writer, attrs) do
    Map.put(attrs, :writer_id, writer.id)
  end

  def fixture(%Writer{} = writer) do
    {:ok, articles} = Publications.create_articles(create_valid_attrs(writer, @create_attrs))
    articles
  end

  def fixture(%Writer{} = writer, story) do
    {:ok, article} = Publications.create_articles(create_valid_attrs(writer, story))
    {:ok, writer, article}
  end

  setup %{conn: conn} do
    {:ok, first_writer} = Accounts.create_writer(@create_writer_attrs)
    {:ok, second_writer} = Accounts.create_writer(@second_writer_attrs)
    {:ok, third_writer} = Accounts.create_writer(@third_writer_attrs)
    {:ok, fourth_writer} = Accounts.create_writer(@fourth_writer_attrs)
    {:ok, token, _claims} = BadgerApi.Auth.Guardian.encode_and_sign(first_writer)
    conn = conn |> put_req_header("authorization", "bearer: " <> token)

    {:ok,
     conn: conn,
     writer: first_writer,
     second_writer: second_writer,
     third_writer: third_writer,
     fourth_writer: fourth_writer}
  end

  describe "index" do
    @tag :list_all_articles
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.articles_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create articles" do
    @tag :create_articles
    test "renders articles when data is valid", %{conn: conn} do
      conn = post(conn, Routes.articles_path(conn, :create), articles: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.articles_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some content",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.articles_path(conn, :create), articles: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update articles" do
    setup [:create_articles]

    test "renders articles when data is valid", %{
      conn: conn,
      articles: %Articles{id: id} = articles
    } do
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

    test "renders errors when a different user is logged in", %{conn: conn, articles: articles} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      conn = BadgerApi.Auth.Guardian.Plug.sign_in(conn, writer)
      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @update_attrs)

      assert %{"detail" => "You're not authorized to update this post"} =
               json_response(conn, 401)["errors"]
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

    test "delete story when a different user is logged in", %{conn: conn, articles: articles} do
      {:ok, writer} = Accounts.create_writer(@updated_writer_attrs)
      conn = BadgerApi.Auth.Guardian.Plug.sign_in(conn, writer)

      conn = put(conn, Routes.articles_path(conn, :update, articles), articles: @update_attrs)

      assert response(conn, 401)
    end
  end

  @tag :get_feed_articles
  describe "get user feed" do
    setup [:create_list_articles]

    test "get user feed based on the topics and users they've followed", %{
      conn: conn,
      articles: articles
    } do
      conn = get(conn, Routes.articles_path(conn, :list_feed_articles))
      assert json_response(conn, 200)
      retrieved_articles = Enum.map(json_response(conn, 200)["data"], & &1["id"])

      assert Enum.all?(articles, fn article -> article.id in retrieved_articles end)
    end
  end

  defp create_list_articles(%{
         writer: first_writer,
         second_writer: second_writer,
         third_writer: third_writer,
         fourth_writer: fourth_writer
       }) do
    {:ok, topic} = Badge.create_topics(@create_topics_attrs)
    {:ok, first_writer, first_article} = fixture(first_writer, @first_story_attrs)
    {:ok, second_writer, second_article} = fixture(second_writer, @second_story_attrs)
    {:ok, third_writer, third_article} = fixture(third_writer, @third_story_attrs)
    {:ok, _fourth_writer, fourth_article} = fixture(fourth_writer, @fourth_story_attrs)
    Accounts.follow(first_writer.id, second_writer.id)
    Accounts.follow(first_writer.id, third_writer.id)
    Context.create_topics_interest(%{writer_id: first_writer.id, topics_id: topic.id})

    {:ok, articles: [first_article, second_article, third_article, fourth_article]}
  end

  defp create_articles(%{writer: writer}) do
    articles = fixture(writer)
    {:ok, articles: articles}
  end
end
