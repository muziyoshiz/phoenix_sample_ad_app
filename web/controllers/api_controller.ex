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

  defp read_configs_from_hbase(_id) do
    Poison.decode!(~s|["http://ad1.example.com/tag.js","http://ad2.example.com/tag.js"]|)
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
    Logger.info("#{id}\t#{callback}", access_log: true)
  end

  defp write_access_log_to_hbase(_id, _callback) do

  end
end
