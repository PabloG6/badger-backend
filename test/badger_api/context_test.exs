defmodule BadgerApi.ContextTest do
  use BadgerApi.DataCase

  alias BadgerApi.Context
  alias BadgerApi.Accounts
  alias BadgerApi.Badge

  describe "topics_interest" do
    alias BadgerApi.Context.InterestedinTopics

    @valid_writer_attrs %{
      name: "Apple Man",
      username: "@appleman",
      password: "password",
      email: "appleman@gmail.com"
    }
    @valid_topics_attrs %{
      title: "some title"
    }

    @invalid_attrs %{}

    def topics_interest_fixture() do
      {:ok, writer} = Accounts.create_writer(@valid_writer_attrs)
      {:ok, topics} = Badge.create_topics(@valid_topics_attrs)

      {:ok, topics_interest} =
        Context.create_topics_interest(%{writer_id: writer.id, topics_id: topics.id})

      {:ok, writer, topics, topics_interest}
    end

    @tag :list_topics_interest
    test "list_topics_interest/1 returns all topics_interest" do
      {:ok, writer, topics, _topics_interest} = topics_interest_fixture()
      page = Context.list_topics_interest(writer.id)

      listed_topics = page.entries
      IO.inspect(listed_topics)

      assert listed_topics == [
               %{topics | description: "No description"}
             ]
    end

    test "get_topics_interest!/1 returns the topics_interest with given id" do
      {:ok, writer, topics, _topics_interest} = topics_interest_fixture()
      assert Context.is_following?(writer.id, topics.id) == true
    end

    test "create_topics_interest/1 with valid data creates a topics_interest" do
      {:ok, writer} = Accounts.create_writer(@valid_writer_attrs)
      {:ok, topics} = Badge.create_topics(@valid_topics_attrs)

      assert {:ok, %InterestedinTopics{}} =
               Context.create_topics_interest(%{writer_id: writer.id, topics_id: topics.id})
    end

    test "create_topics_interest/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_topics_interest(@invalid_attrs)
    end

    test "delete_topics_interest/1 deletes the topics_interest" do
      {:ok, _writer, _topics, topics_interest} = topics_interest_fixture()

      assert {:ok, %InterestedinTopics{}} = Context.delete_topics_interest(topics_interest)
      assert_raise Ecto.NoResultsError, fn -> Context.get_topics_interest!(topics_interest.id) end
    end
  end
end
