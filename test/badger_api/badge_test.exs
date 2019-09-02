defmodule BadgerApi.BadgeTest do
  use BadgerApi.DataCase

  alias BadgerApi.Badge

  describe "topics" do
    alias BadgerApi.Badge.Topics

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def topics_fixture(attrs \\ %{}) do
      {:ok, topics} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Badge.create_topics()

      topics
    end

    test "list_topics/0 returns all topics" do
      topics = topics_fixture()
      assert Badge.list_topics() == [topics]
    end

    test "get_topics!/1 returns the topics with given id" do
      topics = topics_fixture()
      assert Badge.get_topics!(topics.id) == topics
    end

    test "create_topics/1 with valid data creates a topics" do

      assert {:ok, %Topics{} = topics} = Badge.create_topics(@valid_attrs)
      assert topics.description == "some description"
      assert topics.title == String.trim("some title", " ") |> String.replace(" ", "-")
    end

    test "create_topics/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Badge.create_topics(@invalid_attrs)
    end

    test "update_topics/2 with valid data updates the topics" do
      topics = topics_fixture()
      assert {:ok, %Topics{} = topics} = Badge.update_topics(topics, @update_attrs)
      assert topics.description == "some updated description"
      assert topics.title == "some updated title"
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
  end
end
