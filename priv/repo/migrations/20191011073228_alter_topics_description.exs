defmodule BadgerApi.Repo.Migrations.AlterTopicsDescription do
  use Ecto.Migration

  def up do
    alter table(:topics) do
      modify :description, :text, default: "No description"
    end
  end
end
