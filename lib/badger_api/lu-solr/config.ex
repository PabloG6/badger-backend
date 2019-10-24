defmodule Lusolr.Config do
  @moduledoc """
    Config wrapper made in solr
  """
  def info do
    %{
      hostname: hostname(),
      port: port(),
      core: core(),
    }
  end

  def hostname, do: Application.get_env(:search, :hostname)
  def port, do: Application.get_env(:search, :port)
  def core, do: Application.get_env(:search, :core)

  @doc """
  Returns the base url to do `select` queries to solr
  ## Examples
  iex> Lusolr.Config.select_url
  "http://localhost:8983/solr/badger_search/select"
  """
  def select_url, do: "#{base_url()}/select"

  @doc """
  Returns the base url to `update` queries to solr
  ## Examples iex> Lusolr.Config.update_url
  "http://localhost:8983/solr/badger_search/update"
  """
  def update_url, do: "#{base_url()}/update"

  defp base_url, do: "http://#{hostname()}:#{port()}/solr/#{core()}"

end
