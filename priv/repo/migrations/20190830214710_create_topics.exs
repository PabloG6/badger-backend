defmodule BadgerApi.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false) do
      add :title, :string
      add :description, :string
      add :id, :binary_id, primary_key: true
      timestamps()
    end

    create unique_index(:topics, [:title])
  end
end
