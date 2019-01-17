defmodule Biggie do

  @moduledoc """
  Provides a client for programmatically interfacing with BigQuery

  Relevant models:
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Api.Jobs.html#bigquery_jobs_list/3
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.Job.html#content
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.JobConfiguration.html#content
  https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.JobConfigurationQuery.html#content
  """

  alias Biggie.Api
  alias Biggie.Models.{
    Job,
    JobConfiguration,
    JobConfigurationQuery
  }

  require Logger

  @poll_interval 4_000 # four seconds

  @doc """
  Runs a query job

  Given an SQL query to execute and a list of options,
  runs a query job on BigQuery. Returns a reference to
  the job for accessing query results later on.

  Options available here: https://hexdocs.pm/google_api_big_query/GoogleApi.BigQuery.V2.Model.JobConfigurationQuery.html#module-attributes
  """
  def run_query_job(sql, labels \\ %{}, opts \\ %{}) do
    job =
      opts
      |> Map.put(:query, sql)
      |> JobConfigurationQuery.assemble()
      |> JobConfiguration.with_query()
      |> JobConfiguration.with_labels(labels)
      |> Job.with_configuration()

    Api.Jobs.insert(body: job)
  end

  @doc """
  Fetches a list of results for the given job. If the job is not finished,
  the process will poll until it is.
  """
  def fetch_results(job_id, offset \\ 0, limit \\ 500, acc \\ []) do
    case poll_for_results(job_id, offset, limit) do
      {:ok, %{rows: nil}}  -> acc
      {:ok, %{rows: rows}} ->
        fetch_results(job_id, offset + limit, limit, rows ++ acc)

      {:error, reason} ->
        Logger.error("Could not fetch job results: #{inspect(reason)}")
        raise(reason)
    end
  end

  @doc """
  Lists rows in the given table.
  """
  def tabledata_list(dataset_id, table_id, offset \\ 0, limit \\ 500) do
    Api.Tabledata.list([dataset_id, table_id], [
      maxResults: limit,
      startIndex: offset
    ])
  end

  @doc """
  Polls for query results

  If the query is done, results will be returned. If the query
  is still running, sleeps for an interval defined in the
  @poll_interval module attribute and then tries again.
  """
  def poll_for_results(job_id, offset, limit, poll \\ 0)
  def poll_for_results(_job_id, _offset, _limit, poll) when poll > 5 do
    {:error, :timeout}
  end
  def poll_for_results(job_id, offset, limit, poll) do
    case Api.Jobs.get_query_results(job_id, [maxResults: limit, startIndex: offset]) do
      {:ok, %{jobComplete: true} = results} -> {:ok, results}
      {:ok, %{jobComplete: false}} ->
        :timer.sleep(@poll_interval)
        poll_for_results(job_id, offset, limit, poll + 1)

      error -> error
    end
  end
end
