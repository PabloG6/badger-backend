defmodule BadgerApi.PublicationsTest do
  use BadgerApi.DataCase

  alias BadgerApi.Publications

  describe "articles" do
    alias BadgerApi.Publications.Articles
    alias BadgerApi.Accounts
    alias BadgerApi.Badge
    alias BadgerApi.Context
    @valid_attrs %{content: "some content", description: "some description", title: "some title"}
    @update_attrs %{
      content: "some updated content",
      description: "some updated description",
      title: "some updated title"
    }
    @invalid_attrs %{content: nil, description: nil, title: nil}

    @create_writer_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some password_hash",
      username: "@someusername"
    }

    @create_topics_attrs %{
      title: "Fourth Topic"
    }

    @second_writer_attrs %{
      email: "other@email.com",
      name: "other name",
      password: "some password_hash",
      username: "@othername"
    }

    @third_writer_attrs %{
      email: "third@email.com",
      name: "third name",
      password: "some password_hash",
      username: "@thirdname"
    }

    @fourth_writer_attrs %{
      email: "fourth@email.com",
      name: "fourth name",
      password: "some password_hash",
      username: "@fourth name"
    }

    @second_story_attrs %{
      content: "second story",
      title: "second title",
      description: "second description"
    }

    @third_story_attrs %{
      title: "third story",
      description: "third description",
      content: "third story"
    }

    @fourth_story_attrs %{
      categories: ["Fourth Topic"],
      title: "fourth story",
      description: "fourth description",
      content: "third story"
    }
    defp create_valid_attrs(writer, attrs) do
      Map.put(attrs, :writer_id, writer.id)
    end

    def articles_fixture(writer_attrs \\ @create_writer_attrs, attrs \\ %{}) do
      {:ok, writer} = Accounts.create_writer(writer_attrs)

      {:ok, articles} =
        writer
        |> create_valid_attrs(attrs)
        |> Enum.into(@valid_attrs)
        |> Publications.create_articles()

      {:ok, writer, articles}
    end

    test "list_articles/0 returns all articles" do
      {:ok, _writer, articles} = articles_fixture()
      assert Publications.list_articles() == [articles |> Repo.preload(:writer)]
    end

    test "get_articles!/1 returns the articles with given id" do
      {:ok, _writer, articles} = articles_fixture()
      assert Publications.get_articles!(articles.id) == articles
    end

    test "create_articles/1 with valid data creates a articles" do
      {:ok, writer} = Accounts.create_writer(@create_writer_attrs)

      assert {:ok, %Articles{} = articles} =
               Publications.create_articles(create_valid_attrs(writer, @valid_attrs))

      assert articles.content == "some content"
      assert articles.description == "some description"
      assert articles.title == "some title"
    end

    test "create_articles/1 with invalid data returns error changeset" do
      {:ok, writer} = Accounts.create_writer(@create_writer_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Publications.create_articles(create_valid_attrs(writer, @invalid_attrs))
    end

    test "update_articles/2 with valid data updates the articles" do
      {:ok, _writer, articles} = articles_fixture()
      assert {:ok, %Articles{} = articles} = Publications.update_articles(articles, @update_attrs)
      assert articles.content == "some updated content"
      assert articles.description == "some updated description"
      assert articles.title == "some updated title"
    end

    test "update_articles/2 with invalid data returns error changeset" do
      {:ok, _writer, articles} = articles_fixture()
      assert {:error, %Ecto.Changeset{}} = Publications.update_articles(articles, @invalid_attrs)
      assert articles == Publications.get_articles!(articles.id)
    end

    test "delete_articles/1 deletes the articles" do
      {:ok, _writer, articles} = articles_fixture()
      assert {:ok, %Articles{}} = Publications.delete_articles(articles)
      assert_raise Ecto.NoResultsError, fn -> Publications.get_articles!(articles.id) end
    end

    test "change_articles/1 returns a articles changeset" do
      {:ok, _writer, articles} = articles_fixture()
      assert %Ecto.Changeset{} = Publications.change_articles(articles)
    end

    @tag :list_feed_articles
    test "list_feed_articles/1 returns your user feed" do
      {:ok, topic} = Badge.create_topics(@create_topics_attrs)
      {:ok, first_writer, first_article} = articles_fixture()

      {:ok, second_writer, second_article} =
        articles_fixture(@second_writer_attrs, @second_story_attrs)

      {:ok, third_writer, third_article} =
        articles_fixture(@third_writer_attrs, @third_story_attrs)

      {:ok, _fourth_writer, fourth_article} =
        articles_fixture(@fourth_writer_attrs, @fourth_story_attrs)

      Accounts.follow(first_writer.id, second_writer.id)
      Accounts.follow(first_writer.id, third_writer.id)

      Context.create_topics_interest(%{topics_id: topic.id, writer_id: first_writer.id})
      retrieved_articles = Enum.map(Publications.list_feed_articles(first_writer.id), & &1.id)

      assert Enum.all?(
               [first_article.id, second_article.id, third_article.id, fourth_article.id],
               fn article_id -> article_id in retrieved_articles end
             )
    end
  end
end
