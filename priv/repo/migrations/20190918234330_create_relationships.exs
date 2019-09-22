defmodule BadgerApi.Repo.Migrations.CreateRelationships do
  use Ecto.Migration

  def change do
    create table(:relationships) do
      add :follower_id, references(:writers, on_delete: :delete_all, type: :uuid)
      add :following_id, references(:writers, on_delete: :delete_all, type: :uuid)
      timestamps()
    end

    create unique_index(:relationships, [:follower_id, :following_id])
  end
end
