defmodule BadgerApi.Repo.Migrations.ModifyTopicTitle do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      modify :title, :text, null: false
    end
  end
end
