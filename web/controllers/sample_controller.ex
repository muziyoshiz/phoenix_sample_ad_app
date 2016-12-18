defmodule PhoenixSampleAdApp.SampleController do
  use PhoenixSampleAdApp.Web, :controller
  require Logger

  def index(conn, %{"id" => id, "callback" => callback}) do
    urls = case Cachex.get(:ad_cache, id) do
      { :missing, _ } ->
        Logger.debug "Failed to read from cache"
        latest_urls = ["http://ad1.example.com/tag.js", "http://ad2.example.com/tag.js"]
        Cachex.set(:ad_cache, id, latest_urls, [ ttl: :timer.seconds(10) ])
        latest_urls
      { :ok, cache } ->
        Logger.debug "Read from cache"
        cache
      _ ->
        # Unexpected error
        []
    end

    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end
end
