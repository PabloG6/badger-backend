defmodule BadgerApi.AccountsTest do
  use BadgerApi.DataCase

  alias BadgerApi.Accounts

  describe "writers" do
    alias BadgerApi.Accounts.Writer

    @valid_attrs %{description: "some description",
    email: "some@email.com",
     name: "some name",
     username: "@someusername",
    password: "some password"}
    @update_attrs %{description: "some updated description",
    email: "someupdated@email.com",
    name: "some updated name",
    username: "@someupdatedusername",
    password: "some updated password"}
    @invalid_attrs %{description: nil, email: nil, name: nil, username: nil, password: nil}

    def writer_fixture(attrs \\ %{}) do
      {:ok, writer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_writer()

      writer
    end

    test "list_writers/0 returns all writers" do
      writer = writer_fixture()
      assert Accounts.list_writers() == [%{writer | password: nil}]
    end

    test "get_writer!/1 returns the writer with given id" do
      writer = writer_fixture()
      assert Accounts.get_writer!(writer.id) == %{writer | password: nil}
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
      assert %{writer | password: nil} == Accounts.get_writer!(writer.id)

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
end
