defmodule BadgerApi.Repo.Migrations.AlterTopicsTableSlugColumnText do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      modify :slug, :text, null: false
    end
  end
end
