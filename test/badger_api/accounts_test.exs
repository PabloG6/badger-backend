defmodule BadgerApi.AccountsTest do
  use BadgerApi.DataCase

  alias BadgerApi.Accounts
  alias BadgerApi.Badge

  describe "writers" do
    alias BadgerApi.Accounts.Writer

    @valid_attrs %{
      description: "some description",
      email: "some@email.com",
      name: "some name",
      username: "@someusername",
      writes_about_topics: ["hip hop", "cooking", "lifestyle"],
      password: "some password"
    }

    @lifestyle_hack_attrs %{title: "Topics one"}

    @valid_attrs_interest %{
      description: "some description",
      email: "some@email.com",
      name: "some name",
      username: "@someusername",
      password: "some password"
    }

    @update_attrs %{
      description: "some updated description",
      email: "someupdated@email.com",
      name: "some updated name",
      username: "@someupdatedusername",
      password: "some updated password"
    }
    @invalid_attrs %{description: nil, email: nil, name: nil, username: nil, password: nil}

    def writer_fixture(attrs \\ %{}) do
      {:ok, writer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_writer()

      writer
    end

    def topics_fixture(attrs \\ %{}) do
      {:ok, topics} = attrs |> Enum.into(@lifestyle_hack_attrs) |> Badge.create_topics()
      topics
    end

    test "list_writers/0 returns all writers" do
      writer = writer_fixture()
      page = Accounts.list_writers()
      assert page.entries == [%{writer | password: nil}]
    end

    test "get_writer!/1 returns the writer with given id" do
      writer = writer_fixture()

      writer_check = Accounts.get_writer!(writer.id)

      assert writer.id == writer_check.id
      assert writer.username == writer_check.username
      assert writer.name == writer_check.name
      assert writer.email == writer_check.email
      assert writer.description == writer_check.description
    end

    test "create_writer/1 with valid data that contains writes_about_topics" do
      assert {:ok, %Writer{} = writer} = Accounts.create_writer(@valid_attrs_interest)
      assert writer.description == "some description"
      assert writer.email == "some@email.com"
      assert writer.name == "some name"
      assert writer.username == "@someusername"
    end

    test "create_writer/1 with a topic already created" do
      _ = topics_fixture()
      assert {:ok, %Writer{} = writer} = Accounts.create_writer(@valid_attrs_interest)
      assert writer.description == "some description"
      assert writer.email == "some@email.com"
      assert writer.name == "some name"
      assert writer.username == "@someusername"
    end

    test "create_writer/1 with valid data creates a writer" do
      assert {:ok, %Writer{} = writer} = Accounts.create_writer(@valid_attrs)
      assert writer.description == "some description"
      assert writer.email == "some@email.com"
      assert writer.name == "some name"
      assert writer.username == "@someusername"

      assert Bcrypt.verify_pass("some password", writer.password_hash)
    end

    test "create_writer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_writer(@invalid_attrs)
    end

    test "update_writer/2 with valid data updates the writer" do
      writer = writer_fixture()
      assert {:ok, %Writer{} = writer} = Accounts.update_writer(writer, @update_attrs)
      assert writer.description == "some updated description"
      assert writer.email == "someupdated@email.com"
      assert writer.name == "some updated name"
      assert writer.username == "@someupdatedusername"
      assert Bcrypt.verify_pass("some updated password", writer.password_hash)
    end

    test "update_writer/2 with invalid data returns error changeset" do
      writer = writer_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_writer(writer, @invalid_attrs)
    end

    test "delete_writer/1 deletes the writer" do
      writer = writer_fixture()
      assert {:ok, %Writer{}} = Accounts.delete_writer(writer)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_writer!(writer.id) end
    end

    test "change_writer/1 returns a writer changeset" do
      writer = writer_fixture()
      assert %Ecto.Changeset{} = Accounts.change_writer(writer)
    end
  end

  describe "relationships" do
    alias BadgerApi.Accounts.Writer
    alias BadgerApi.Accounts.Relationships

    def relationships_fixture(:relationships) do
      {:ok, writer} = Accounts.create_writer(@valid_attrs)
      {:ok, other_writer} = Accounts.create_writer(@update_attrs)
      {:ok, relationships} = Accounts.follow(writer.id, other_writer.id)
      {writer, other_writer, relationships}
    end

    @doc """
    simply create two random users
    e.g
    iex> relationships_fixture(:follow)
    {%Writer{}, %Writer{}}
    """
    def relationships_fixture(:follow) do
      {:ok, writer} = Accounts.create_writer(@valid_attrs)
      {:ok, other_writer} = Accounts.create_writer(@update_attrs)

      {writer, other_writer}
    end

    @tag :followers
    test "followers/1 returns all followers for specific user" do
      {first_writer, second_writer, _} = relationships_fixture(:relationships)
      page = Accounts.followers(second_writer.id)

      assert Enum.map(page.entries, &%Writer{&1 | writes_about_topics: []}) ==
               [%Writer{first_writer | password: nil, writes_about_topics: []}]
    end

    @tag :following
    test "following/1 returns all users following this user" do
      {first_writer, second_writer, _} = relationships_fixture(:relationships)

      assert Enum.map(
               Accounts.following(first_writer.id),
               &%Writer{&1 | writes_about_topics: []}
             ) ==
               [%Writer{second_writer | password: nil, writes_about_topics: []}]
    end

    test "follow/1 follows a specific user" do
      {writer, writer_to_follow} = relationships_fixture(:follow)
      {:ok, relationship} = Accounts.follow(writer.id, writer_to_follow.id)
      assert Accounts.is_following?(writer.id, writer_to_follow.id) == relationship
    end

    test "unfollow/1 unfollows a specific user" do
      {writer, writer_to_unfollow, %Relationships{} = followed_relationship} =
        relationships_fixture(:relationships)

      {:ok, %Relationships{} = unfollowed_relationship} =
        Accounts.unfollow(writer.id, writer_to_unfollow.id)

      assert %Relationships{unfollowed_relationship | __meta__: nil} == %Relationships{
               followed_relationship
               | __meta__: nil
             }
    end

    test "is_following?/1 check if one user is following another" do
      {first_writer, second_writer, relationship} = relationships_fixture(:relationships)
      relationship_check = Accounts.is_following?(first_writer.id, second_writer.id)
      assert relationship == relationship_check
    end
  end
end
