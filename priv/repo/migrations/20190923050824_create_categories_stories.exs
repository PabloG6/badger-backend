defmodule BadgerApi.Repo.Migrations.CreateCategoriesStories do
  use Ecto.Migration

  def change do
    create table(:categories_stories) do
      add :categories_id, references(:topics, on_delete: :delete_all, type: :uuid)
      add :stories_id, references(:stories, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create unique_index(:categories_stories, [:categories_id, :stories_id])

  end
end
