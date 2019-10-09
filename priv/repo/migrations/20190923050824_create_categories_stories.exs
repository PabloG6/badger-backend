defmodule BadgerApi.Repo.Migrations.CreateCategoriesArticles do
  use Ecto.Migration

  def change do
    create table(:categories_articles) do
      add :categories_id, references(:topics, on_delete: :delete_all, type: :uuid)
      add :articles_id, references(:articles, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create unique_index(:categories_articles, [:categories_id, :articles_id])
  end
end
