defmodule BadgerApi.Publications.TestHelper do

  alias BadgerApi.Accounts
  alias BadgerApi.Publications
  alias Ecto
  def create_writer(%{} = changeset) do
    Accounts.create_writer(changeset)
  end

  def create_stories(writer, %{} = changeset) do
    writer |> Ecto.build_assoc(:stories, changeset) |> Publications.create_stories()

  end




end
