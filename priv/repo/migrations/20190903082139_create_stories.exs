defmodule BadgerApi.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :body, :string, null: false
      add :description, :string
      add :writer_id, references(:writers, type: :binary_id)


      timestamps()
    end

  end
end
