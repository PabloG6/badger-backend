defmodule BadgerApi.Publications.TestHelper do

  alias BadgerApi.Accounts
  alias BadgerApi.Publications
  alias Ecto
  def create_writer(%{} = changeset) do
    Accounts.create_writer(changeset)
  end

  def create_articles(writer, %{} = changeset) do
    writer |> Ecto.build_assoc(:articles, changeset) |> Publications.create_articles()

  end




end
