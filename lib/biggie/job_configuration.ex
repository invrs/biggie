defmodule Biggie.Models.JobConfiguration do
  alias GoogleApi.BigQuery.V2.Model.JobConfiguration, as: Base
  alias GoogleApi.BigQuery.V2.Model.JobConfigurationQuery, as: Query

  def with_query(%Query{} = query), do: %Base{} |> Map.put(:query, query)

  def with_labels(%Base{} = base, labels) when is_map(labels), do: Map.put(base, :labels, labels)
end
