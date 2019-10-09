defmodule BadgerApi.Repo.Migrations.AddArticlesCoverPhoto do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :cover_photo, :string
      modify :title, :text
      modify :body, :text
    end

    rename table(:articles), :body, to: :content
  end
end
