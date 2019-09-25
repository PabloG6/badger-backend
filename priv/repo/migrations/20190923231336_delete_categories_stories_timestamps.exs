defmodule BadgerApi.Repo.Migrations.DeleteCategoriesStoriesTimestamps do
  use Ecto.Migration

  def change do
    alter table(:categories_stories) do
      remove :inserted_at
      remove :updated_at
    end


  end
end
