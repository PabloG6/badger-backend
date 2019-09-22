defmodule BadgerApi.Repo.Migrations.WritersTopics do
  use Ecto.Migration

  def change do
    create table(:writers_topics) do
      add :writer_id, references(:writers, type: :uuid)
      add :topics_id, references(:topics, type: :uuid)
    end
    create unique_index(:writers_topics, [:writer_id, :topics_id])

  end

end
