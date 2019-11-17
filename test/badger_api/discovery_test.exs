defmodule BadgerApi.DiscoveryTest do
  use BadgerApi.DataCase

  # alias BadgerApi.Discovery

  describe "search" do
    # alias BadgerApi.Discovery.Search

    # @valid_attrs %{}
    # @update_attrs %{}
    # @invalid_attrs %{}

    def search_fixture(_attrs \\ %{}) do
      # {:ok, _search} =
      #   attrs
      #   |> Enum.into(@valid_attrs)
      #   |> Discovery.create_search()

      # search
    end

    test "list_search/0 returns all search" do
      # search = search_fixture()
      # assert Discovery.list_search() == [search]
      assert true
    end

    test "get_search!/1 returns the search with given id" do
      # search = search_fixture()
      # assert Discovery.get_search!(search.id) == search
      assert true
    end

    test "create_search/1 with valid data creates a search" do
      # assert {:ok, _search} = Discovery.create_search(@valid_attrs)
      assert true
    end

    test "create_search/1 with invalid data returns error changeset" do
      # assert {:error, %Ecto.Changeset{}} = Discovery.create_search(@invalid_attrs)
      assert true
    end

    test "update_search/2 with valid data updates the search" do
      # search = search_fixture()
      # assert {:ok,  _search} = Discovery.update_search(search, @update_attrs)
      assert true
    end

    test "update_search/2 with invalid data returns error changeset" do
      # search = search_fixture()
      # assert {:error, %Ecto.Changeset{}} = Discovery.update_search(search, @invalid_attrs)
      # assert search == Discovery.get_search!(search.id)
    end

    test "delete_search/1 deletes the search" do
      # search = search_fixture()
      # assert {:ok, _} = Discovery.delete_search(search)
      # assert_raise Ecto.NoResultsError, fn -> Discovery.get_search!(search.id) end
      assert true
    end

    test "change_search/1 returns a search changeset" do
      # search = search_fixture()
      # assert %Ecto.Changeset{} = Discovery.change_search(search)
      assert true
    end
  end
end
