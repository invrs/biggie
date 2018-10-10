defmodule Biggie.Models.JobConfigurationQuery do
  alias GoogleApi.BigQuery.V2.Model.JobConfigurationQuery, as: Base

  @moduledoc """
  See https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.JobConfigurationQuery.html#module-attributes
  """

  def assemble(params), do: %Base{} |> Map.merge(params)
end
