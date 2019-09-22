defmodule BadgerApi.Repo.Migrations.AlterTopicsTableSlugColumn do
  use Ecto.Migration


  def change do
    alter table(:topics) do
      modify :slug, :string, null: false
    end
  end
end

