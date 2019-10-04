defmodule BadgerApi.Repo.Migrations.DeleteCategoriesArticlesTimestamps do
  use Ecto.Migration

  def change do
    alter table(:categories_articles) do
      remove :inserted_at
      remove :updated_at
    end


  end
end
