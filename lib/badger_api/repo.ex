defmodule BadgerApi.Repo do
  use Ecto.Repo,
    otp_app: :badger_api,
    adapter: Ecto.Adapters.Postgres
end
