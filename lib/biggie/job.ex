defmodule Biggie.Models.Job do

  @moduledoc """
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.Job.html#module-attributes
  """

  alias GoogleApi.BigQuery.V2.Model.Job,              as: Base
  alias GoogleApi.BigQuery.V2.Model.JobConfiguration, as: Configuration

  def with_configuration(%Configuration{} = configuration),
    do: %Base{} |> Map.put(:configuration, configuration)
end
