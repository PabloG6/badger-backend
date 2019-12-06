defmodule BadgerApi.BadgeTest do
  use BadgerApi.DataCase

  alias BadgerApi.Badge

  describe "topics" do
    alias BadgerApi.Badge.Topics
    alias BadgerApi.Accounts
    alias BadgerApi.Publications
    import Recase

    import BadgerApi.Factory

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}
    @writer_attrs %{
      name: "some writer",
      username: "@somewriter",
      email: "somewriter@gmail.com",
      password: "password"
    }

    @story_attrs %{
      description: "some story description",
      content: "some story content",
      title: "some title",
      categories: ["topic one", "topic two", "topic three"]
    }
    @topics_attrs %{title: "topic one"}
    @other_story_attrs %{
      description: "some other story description",
      content: "some ohter story content",
      title: "some other title",
      categories: ["topic one", "topic four", "topic five"]
    }

    @third_story_attrs %{
      description: "some third story description",
      content: "some third story content",
      title: "some third title",
      categories: ["topic seven", "topic eight", "topic nine"]
    }
    def topics_fixture(attrs \\ %{}) do
      {:ok, topics} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Badge.create_topics()

      topics
    end

    def filter_articles() do
      {:ok, writer} = Accounts.create_writer(@writer_attrs)

      {:ok, articles} = Publications.create_articles(Map.put(@story_attrs, :writer_id, writer.id))

      {:ok, other_articles} =
        Publications.create_articles(Map.put(@other_story_attrs, :writer_id, writer.id))

      {:ok, third_articles} =
        Publications.create_articles(Map.put(@third_story_attrs, :writer_id, writer.id))

      {:ok, [articles, other_articles], writer, third_articles}
    end

    test "list_topics/0 returns all topics" do
      topics = topics_fixture()
      page = Badge.list_topics()
      assert page.entries == [topics]
    end

    test "get_topics!/1 returns the topics with given id" do
      topics = topics_fixture()
      assert Badge.get_topics!(topics.id) == topics
    end

    test "create_topics/1 with valid data creates a topics" do
      assert {:ok, %Topics{} = topics} = Badge.create_topics(@valid_attrs)
      assert topics.description == "some description"
      assert topics.title == "some title" |> to_title
    end

    test "create_topics/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Badge.create_topics(@invalid_attrs)
    end

    test "update_topics/2 with valid data updates the topics" do
      topics = topics_fixture()
      assert {:ok, %Topics{} = topics} = Badge.update_topics(topics, @update_attrs)
      assert topics.description == "some updated description"
      assert topics.title == "some updated title" |> to_title
    end

    test "update_topics/2 with invalid data returns error changeset" do
      topics = topics_fixture()
      assert {:error, %Ecto.Changeset{}} = Badge.update_topics(topics, @invalid_attrs)
      assert topics == Badge.get_topics!(topics.id)
    end

    test "delete_topics/1 deletes the topics" do
      topics = topics_fixture()
      assert {:ok, %Topics{}} = Badge.delete_topics(topics)
      assert_raise Ecto.NoResultsError, fn -> Badge.get_topics!(topics.id) end
    end

    test "change_topics/1 returns a topics changeset" do
      topics = topics_fixture()
      assert %Ecto.Changeset{} = Badge.change_topics(topics)
    end

    @tag :filter_articles
    test "filter_articles/1 returns a list of articles based on slug passed" do
      topic = topics_fixture(@topics_attrs)
      {:ok, articles, _writer, _third_articles} = filter_articles()

      assert Enum.map(articles, & &1.id) == Enum.map(Badge.filter_articles!(topic.slug), & &1.id)
    end

    @tag :list_topics_by_popularity
    test "list_topics_by_popularity/1 returns a list of topics grouped and ordered alphabetically" do
      topics_list = organize_topics_fixture("Most Popular Topic")
      # check if frirst 10 topics are most-popular-topic
      # Enum.map(topics_list,
      # fn topic ->

      # end)
    end

    def organize_topics_fixture(title) do
      universal_topic = build(:topics_map, title: title)

      Enum.map(
        build_list(10, :articles_map,
          categories: build_list(5, :topics_map) |> convert_to_list,
          writer_id: insert(:writer).id
        ),
        &Publications.create_articles/1
      )

      Enum.map(
        build_list(100, :articles_map,
          categories: [universal_topic] |> convert_to_list,
          writer_id: insert(:writer).id
        ),
        &Publications.create_articles/1
      )
    end

    defp convert_to_list(topics_list) do
      Enum.map(topics_list, & &1.title)
    end
  end
end
