defmodule BadgerApi.PublicationsTest do
  use BadgerApi.DataCase

  alias BadgerApi.Publications

  describe "stories" do
    alias BadgerApi.Publications.Stories
    alias BadgerApi.Accounts
    @valid_attrs %{body: "some body", description: "some description", title: "some title"}
    @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
    @invalid_attrs %{body: nil, description: nil, title: nil}
    @create_writer_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some password_hash",
      username: "@someusername"
    }

    defp create_valid_attrs(writer, attrs) do
      Map.put(attrs, :writer_id, writer.id)

    end
    def stories_fixture(attrs \\ %{}) do
      {:ok, writer} = Accounts.create_writer(@create_writer_attrs)
      {:ok, stories} =
       writer
        |> create_valid_attrs(attrs)
        |> Enum.into(@valid_attrs)
        |> Publications.create_stories()

      stories
    end

    test "list_stories/0 returns all stories" do
      stories = stories_fixture()
      assert Publications.list_stories() == [stories]
    end

    test "get_stories!/1 returns the stories with given id" do
      stories = stories_fixture()
      assert Publications.get_stories!(stories.id) == stories
    end

    test "create_stories/1 with valid data creates a stories" do
      {:ok, writer}  = Accounts.create_writer(@create_writer_attrs)

      assert {:ok, %Stories{} = stories} = Publications.create_stories(create_valid_attrs(writer, @valid_attrs))
      assert stories.body == "some body"
      assert stories.description == "some description"
      assert stories.title == "some title"
    end

    test "create_stories/1 with invalid data returns error changeset" do
      {:ok, writer}  = Accounts.create_writer(@create_writer_attrs)

      assert {:error, %Ecto.Changeset{}} = Publications.create_stories(create_valid_attrs(writer, @invalid_attrs))
    end

    test "update_stories/2 with valid data updates the stories" do
      stories = stories_fixture()
      assert {:ok, %Stories{} = stories} = Publications.update_stories(stories, @update_attrs)
      assert stories.body == "some updated body"
      assert stories.description == "some updated description"
      assert stories.title == "some updated title"
    end

    test "update_stories/2 with invalid data returns error changeset" do
      stories = stories_fixture()
      assert {:error, %Ecto.Changeset{}} = Publications.update_stories(stories, @invalid_attrs)
      assert stories == Publications.get_stories!(stories.id)
    end

    test "delete_stories/1 deletes the stories" do
      stories = stories_fixture()
      assert {:ok, %Stories{}} = Publications.delete_stories(stories)
      assert_raise Ecto.NoResultsError, fn -> Publications.get_stories!(stories.id) end
    end

    test "change_stories/1 returns a stories changeset" do
      stories = stories_fixture()
      assert %Ecto.Changeset{} = Publications.change_stories(stories)
    end
  end
end
