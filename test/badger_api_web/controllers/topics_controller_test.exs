defmodule BadgerApiWeb.TopicsControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Badge
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Accounts
  alias BadgerApi.Context
  alias BadgerApi.Publications
  @create_attrs %{
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{title: nil, description: nil}
  @create_writer_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password_hash",
    username: "@someusername"
  }

  @story_attrs %{description: "some story description",
                    body: "some story body",
                    title: "some title",
                    categories: ["topic one", "topic two", "topic three", "some title"]
                    }

  @other_story_attrs %{description: "some other story description",
                          body: "some ohter story body",
                          title: "some other title",
                          categories: ["topic one", "topic four", "topic five", "some title"]}

  @third_story_attrs %{description: "some third story description",
                        body: "some third story body",
                        title: "some third title",
                        categories: ["topic seven", "topic eight", "topic nine"]}
  def fixture(:topics) do
    {:ok, topics} = Badge.create_topics(@create_attrs)
    topics
  end

  setup %{conn: conn} do
    {:ok, writer} = Accounts.create_writer(@create_writer_attrs)
    {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writer)
     conn = put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, writer: writer}
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
      assert %{"slug" => slug, "id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.topics_path(conn, :show, slug))

      assert %{
               "id" => id,
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.topics_path(conn, :create), topics: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update topics" do
    setup [:create_topics]

    test "renders topics when data is valid", %{conn: conn, topics: %Topics{slug: slug, id: id} = topics} do
      conn = put(conn, Routes.topics_path(conn, :update, topics), topics: @update_attrs)
      assert %{"slug" => ^slug, "id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.topics_path(conn, :show, slug))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "title" => "some updated title",
               "slug" => slug
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

  describe "filter stories" do
    setup [:create_topics, :create_stories]
    @tag :filter_stories
    test "filter stories by topic" , %{conn: conn, stories: stories, topics: topics} do
      conn = get(conn, Routes.topics_path(conn, :filter_stories, topics.slug))
      assert Enum.map(json_response(conn, 200)["data"], &(&1["id"])) ==
        Enum.map(stories, &(&1.id))
    end
  end

  describe "follow topics" do
    setup [:create_topics]
    test "follow a topic", %{conn: conn, topics: topics} do
      conn = post(conn, Routes.topics_path(conn, :follow_topics, topics.slug))
      assert response(conn, 201)
    end


  end

  describe "following topics" do
    setup [:create_topics_interest]

    test "unfollow a topic", %{conn: conn, topics: topics,} do
      conn = delete(conn, Routes.topics_path(conn, :unfollow_topics, topics.slug))
      assert response(conn, 204)
    end

    test "get a list of topics your following", %{conn: conn,  writer: writer} do
      conn = get(conn, Routes.topics_path(conn, :following))
      following = Context.list_topics_interest(writer.id)
      assert json_response(conn, 200)["data"] == Enum.map(following,
       &%{"title"=>&1.title, "id"=>&1.id, "slug"=>&1.slug, "description" => &1.description})
    end

    test "renders 404 when user isn't following a topic", %{conn: conn, topics: topics, topics_interest: topics_interest} do
      Context.delete_topics_interest(topics_interest)
      conn = get(conn, Routes.topics_path(conn, :is_following?, topics.slug))
      assert response(conn, 404)

    end

    test "renders 204 if following a topic", %{conn: conn, topics: topics,} do

      conn = get(conn, Routes.topics_path(conn, :is_following?, topics.slug))
      assert response(conn, 204)
    end
  end

  defp create_topics(_) do
    topics = fixture(:topics)
    {:ok, topics: topics}
  end

  def create_topics_interest(%{writer: writer}) do
    topics = fixture(:topics)
      {:ok, topics_interest} = Context.create_topics_interest(%{writer_id: writer.id, topics_id: topics.id})
    {:ok, topics_interest: topics_interest, topics: topics}

  end


  defp create_stories(%{writer: writer}) do


    {:ok, stories} = Publications.create_stories(Map.put(@story_attrs, :writer_id, writer.id))
    {:ok, other_stories} = Publications.create_stories(Map.put(@other_story_attrs, :writer_id, writer.id))
    {:ok, third_stories} = Publications.create_stories(Map.put(@third_story_attrs, :writer_id, writer.id))

    {:ok, stories: [stories, other_stories,], third_stories: third_stories}
  end
end
