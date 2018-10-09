defmodule Biggie.Api.Jobs do
  @doc """
  Inserts a BigQuery job asynchronously

  On successful creation, events the job reference over the
  pipeline. This allows other services to make use
  of the job status and results as necessary.

  Extends https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Api.Jobs.html#bigquery_jobs_insert/3
  """
  def insert(opts), do: Biggie.Api.request(:bigquery_jobs_insert, [], opts)

  def insert!(opts) do
    case insert(opts) do
      {:ok, result} -> result
      {:error, %{body: body}} -> raise(body)
    end
  end

  @doc """
  Returns query results for the given job

  Extends https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Api.Jobs.html#bigquery_jobs_get_query_results/4
  """
  def get_query_results(job_id, opts \\ []),
    do: Biggie.Api.request(:bigquery_jobs_get_query_results, [job_id], opts)
end
