defmodule BadgerApi.Repo.Migrations.ModifyTopicTidescription do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      modify :description, :text, null: true, default: "No description."
    end
  end
end
