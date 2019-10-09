defmodule BadgerApi.Repo.Migrations.ModifyWriterTable do
  use Ecto.Migration

  def change do
    alter table(:writers) do
      add :password_hash, :text, null: false
    end
  end
end
