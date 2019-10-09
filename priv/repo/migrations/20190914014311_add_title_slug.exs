defmodule BadgerApi.Repo.Migrations.AddTitleSlug do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :slug, :text, null: false
    end

    create unique_index(:topics, [:slug])
  end
end
