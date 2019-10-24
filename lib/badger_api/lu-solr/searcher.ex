defmodule Lusolr.Searcher do
  @moduledoc """
  Provides the search functions to solr
  """
  require Logger
  alias Lusolr.Config
  alias Lusolr.HttpResponse

  @doc """
  sends query with default parameters if no params provided
  """
  def get, do: get(default_parameters)

  def get(params) do
    params
    |> build_solr_query
    |> do_search
    |> extract_response
  end

  @doc """
  Builds the solr url query. Uses default values if no values are specified
  wt: "json"
  q: "*:*"
  start: 0
  rows: 10

  ## Examples

  iex> Lusolr.Searcher.build_solr_query(q: "roses, fq: ["blue", "violet", "orange"]")
  "?wt=json&start=0&rows=10&q=roses&fq=blue&fq=violet"

  iex> Lusolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], start: 0, rows: 10)
  "?wt=json&q=roses&fq=blue&fq=violet&start=0&rows=10"

  iex> Lusolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], wt: "xml")
      "?start=0&rows=10&q=roses&fq=blue&fq=violet&wt=xml"
      """

  def build_solr_query(params) do
        "?" <> build_solr_query_params(params)
  end


  defp default_params do
    [wt: "json", q: "*:*", start: 0, rows: 10]
  end
  defp build_solr_query_params(params) do
    params
    |> add_default_params
    |> Enum.map(fn({key, value}) -> build_solr_query_parameter(key, value) end)
    |> Enum.join("&")

  end

  defp build_solr_query_parameter(_, []), do: nil
  defp build_solr_query_parameter(key, [head|tail]) do
    [build_solr_query_parameter(key, head), build_solr_query_parameter(key, tail)]
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.join("&")
  end


  defp build_solr_query_parameter(:q, value), do: "q=#{URI.encode_www_form(value)}"

  defp build_solr_query_parameter(key, value) do
    [Atom.to_string(key), value]
    |> Enum.join("=")
  end

  def do_search(solr_query) do
    solr_query
    |> build_solr_url
    |> HTTPoison.get
    |> HttpResponse.body

  end

  defp build_solr_url(solr_query) do
    url = Config.select_url <> solr_query
    _ = Logger.debug url
    url
  end

  defp extract_response(solr_response) do
    case solr_response |> Poison.decode do
      {:ok, %{"response" => response "moreLikeThis" => moreLikeThis}} -> Map.put(respone, "mlt", extract_mlt_response(response))  end
  defp add_default_params(params) do
    default_parameters
    |> Keyword.merge(params)
  end

  defp extract_mlt_response(mlt) do

    result =
    for k <- Map.keys(mlt), do: get_in(mlt, [k, "docs"])
    result |> List.flatten

  end
  end

end
