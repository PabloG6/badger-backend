defmodule BadgerApi.Repo.Migrations.CreateWriterTopics do
  use Ecto.Migration

  def change do
    create table(:topics_interests) do
      add :writer_id, references(:writers, on_delete: :nothing, type: :uuid)
      add :topics_id, references(:topics, on_delete: :nothing, type: :uuid)

    end

    create unique_index(:topics_interests, [:writer_id, :topics_id])
  end
end
