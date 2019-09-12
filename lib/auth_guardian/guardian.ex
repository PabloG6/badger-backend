defmodule BadgerApi.Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :badger_api
  alias BadgerApi.Accounts


  def subject_for_token(writer, _claims) do
    sub = to_string(writer.id)
    {:ok, sub}

  end






  def resource_from_claims(claims) do
    id = claims["sub"]
    case Accounts.get_writer!(id) do
      nil -> {:error, :resource_not_found}
      player -> {:ok, player}
    end
  end
end
