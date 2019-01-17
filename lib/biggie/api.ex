defmodule Biggie.Api do
  @moduledoc """
  Defines a client for interacting with the BigQuery REST API
  """

  alias GoogleApi.BigQuery.V2.{Api, Connection}
  require Logger

  @scope "https://www.googleapis.com/auth/cloud-platform"

  def request(method, args \\ [], opts \\ []) do
    Goth.Token.for_scope(@scope) |> _request(method, args, opts)
  end

  defp _request({:ok, %{token: token}}, method, args, opts) do
    project_id = Application.get_env(:biggie, :project_id)
    args       = [Connection.new(token), project_id | args] ++ [opts]
    module     = Module.concat(Api, get_api_module(method))

    IO.puts("[applying] #{inspect(module)} — #{inspect(method)} — #{inspect(args)}")
    apply(module, method, args)
  end

  defp _request({:error, reason}, _method, _args, _opts) do
    {:error, reason}
  end

  defp get_api_module(:bigquery_tabledata_list), do: Tabledata
  defp get_api_module(_),                        do: Jobs
end
