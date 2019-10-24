defmodule BadgerApi.DiscoveryTest do
  use BadgerApi.DataCase

  alias BadgerApi.Discovery

  describe "search" do
    alias BadgerApi.Discovery.Search

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def search_fixture(attrs \\ %{}) do
      {:ok, search} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discovery.create_search()

      search
    end

    test "list_search/0 returns all search" do
      search = search_fixture()
      assert Discovery.list_search() == [search]
    end

    test "get_search!/1 returns the search with given id" do
      search = search_fixture()
      assert Discovery.get_search!(search.id) == search
    end

    test "create_search/1 with valid data creates a search" do
      assert {:ok, %Search{} = search} = Discovery.create_search(@valid_attrs)
    end

    test "create_search/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discovery.create_search(@invalid_attrs)
    end

    test "update_search/2 with valid data updates the search" do
      search = search_fixture()
      assert {:ok, %Search{} = search} = Discovery.update_search(search, @update_attrs)
    end

    test "update_search/2 with invalid data returns error changeset" do
      search = search_fixture()
      assert {:error, %Ecto.Changeset{}} = Discovery.update_search(search, @invalid_attrs)
      assert search == Discovery.get_search!(search.id)
    end

    test "delete_search/1 deletes the search" do
      search = search_fixture()
      assert {:ok, %Search{}} = Discovery.delete_search(search)
      assert_raise Ecto.NoResultsError, fn -> Discovery.get_search!(search.id) end
    end

    test "change_search/1 returns a search changeset" do
      search = search_fixture()
      assert %Ecto.Changeset{} = Discovery.change_search(search)
    end
  end
end
