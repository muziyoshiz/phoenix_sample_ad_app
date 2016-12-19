defmodule PhoenixSampleAdApp.ApiController do
  use PhoenixSampleAdApp.Web, :controller
  require Logger

  @local_cache_ttl :timer.seconds(60)

  @doc """
  No access logs, and fixed configs
  """
  def sample1(conn, %{"callback" => callback}) do
    json = ~s|{"urls":["http://ad1.example.com/tag.js","http://ad2.example.com/tag.js"]}|
    render conn, "sample.js", json: json, callback: callback
  end

  @doc """
  No access logs, and configs from HBase
  """
  def sample2(conn, %{"id" => id, "callback" => callback}) do
    urls = read_configs_from_hbase(id)
    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end

  @doc """
  No access logs, and configs from HBase or local cache
  """
  def sample3(conn, %{"id" => id, "callback" => callback}) do
    urls = read_configs_from_hbase_or_cache(id)
    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end

  @doc """
  Access logs to file, and configs from HBase or local cache
  """
  def sample4(conn, %{"id" => id, "callback" => callback}) do
    write_access_log_to_file(id, callback)
    urls = read_configs_from_hbase_or_cache(id)
    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end

  @doc """
  Access logs to HBase, and configs from HBase or local cache
  """
  def sample5(conn, %{"id" => id, "callback" => callback}) do
    write_access_log_to_hbase(id, callback)
    urls = read_configs_from_hbase_or_cache(id)
    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end

  defp read_configs_from_hbase(id) do
    case Diver.Client.get("settings", id, "f", "urls") do
      { :ok, value } ->
        Poison.decode!(value)
      _ ->
        []
    end
  end

  defp read_configs_from_hbase_or_cache(id) do
    case Cachex.get(:ad_cache, id) do
      { :missing, _ } ->
        urls = read_configs_from_hbase(id)
        Cachex.set(:ad_cache, id, urls, [ ttl: @local_cache_ttl ])
        urls
      { :ok, cache } ->
        cache
      _ ->
        # Unexpected error
        []
    end
  end

  defp write_access_log_to_file(id, callback) do
    log = Poison.encode!(%{"id" => id, "callback" => callback})
    Logger.info(log, access_log: true)
  end

  defp write_access_log_to_hbase(id, callback) do
    # Create unique row key from current time
    rowkey = Enum.join([id, to_string(:os.system_time(:nano_seconds)), to_string(Enum.random(1..10000))], "_")
    log = Poison.encode!(%{"id" => id, "callback" => callback})
    Diver.Client.put("access_logs", rowkey, "f", "log", log)
  end
end
