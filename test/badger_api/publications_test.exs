defmodule BadgerApi.PublicationsTest do
  use BadgerApi.DataCase

  alias BadgerApi.Publications

  describe "articles" do
    alias BadgerApi.Publications.Articles
    alias BadgerApi.Accounts
    @valid_attrs %{content: "some content", description: "some description", title: "some title"}
    @update_attrs %{content: "some updated content", description: "some updated description", title: "some updated title"}
    @invalid_attrs %{content: nil, description: nil, title: nil}
    @create_writer_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some password_hash",
      username: "@someusername"
    }

    defp create_valid_attrs(writer, attrs) do
      Map.put(attrs, :writer_id, writer.id)

    end
    def articles_fixture(attrs \\ %{}) do
      {:ok, writer} = Accounts.create_writer(@create_writer_attrs)
      {:ok, articles} =
       writer
        |> create_valid_attrs(attrs)
        |> Enum.into(@valid_attrs)
        |> Publications.create_articles()

      articles
    end

    test "list_articles/0 returns all articles" do
      articles = articles_fixture()
      assert Publications.list_articles() == [articles |> Repo.preload(:writer)]
    end

    test "get_articles!/1 returns the articles with given id" do
      articles = articles_fixture()
      assert Publications.get_articles!(articles.id) == articles
    end

    test "create_articles/1 with valid data creates a articles" do
      {:ok, writer}  = Accounts.create_writer(@create_writer_attrs)

      assert {:ok, %Articles{} = articles} = Publications.create_articles(create_valid_attrs(writer, @valid_attrs))
      assert articles.content == "some content"
      assert articles.description == "some description"
      assert articles.title == "some title"
    end

    test "create_articles/1 with invalid data returns error changeset" do
      {:ok, writer}  = Accounts.create_writer(@create_writer_attrs)

      assert {:error, %Ecto.Changeset{}} = Publications.create_articles(create_valid_attrs(writer, @invalid_attrs))
    end

    test "update_articles/2 with valid data updates the articles" do
      articles = articles_fixture()
      assert {:ok, %Articles{} = articles} = Publications.update_articles(articles, @update_attrs)
      assert articles.content == "some updated content"
      assert articles.description == "some updated description"
      assert articles.title == "some updated title"
    end

    test "update_articles/2 with invalid data returns error changeset" do
      articles = articles_fixture()
      assert {:error, %Ecto.Changeset{}} = Publications.update_articles(articles, @invalid_attrs)
      assert articles == Publications.get_articles!(articles.id)
    end

    test "delete_articles/1 deletes the articles" do
      articles = articles_fixture()
      assert {:ok, %Articles{}} = Publications.delete_articles(articles)
      assert_raise Ecto.NoResultsError, fn -> Publications.get_articles!(articles.id) end
    end

    test "change_articles/1 returns a articles changeset" do
      articles = articles_fixture()
      assert %Ecto.Changeset{} = Publications.change_articles(articles)
    end
  end
end
