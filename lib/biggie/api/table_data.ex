defmodule Biggie.Api.Tabledata do

  def list(args, opts) do
    Biggie.Api.request(:bigquery_tabledata_list, args, opts)
  end
end
