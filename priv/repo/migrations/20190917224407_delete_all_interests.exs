defmodule BadgerApi.Repo.Migrations.DeleteAllInterests do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE writers_topics DROP CONSTRAINT writers_topics_writer_id_fkey"
    execute "alter table writers_topics drop constraint writers_topics_topics_id_fkey"

    alter table(:writers_topics) do
      modify :writer_id, references(:writers, type: :uuid, on_delete: :delete_all)
      modify :topics_id, references(:topics, type: :uuid, on_delete: :delete_all)
    end

    # create unique_index(:writers_topics, [:writer_id, :topics_id])
  end

  def down do
    execute "alter table writers_topics drop constraint writers_topics_writer_id_fkey"
    execute "alter table writers_topics drop constraint writers_topics_topics_id_fkey"

    alter table(:writers_topics) do
      modify :writer_id, references(:writers, type: :uuid, on_delete: :nothing)
      modify :topics_id, references(:topics, type: :uuid, on_delete: :nothing)
    end
  end
end
