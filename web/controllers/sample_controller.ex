defmodule PhoenixSampleAdApp.SampleController do
  use PhoenixSampleAdApp.Web, :controller
  require Logger

  def index(conn, %{"id" => id, "callback" => callback}) do
    case Cachex.get(:ad_cache, id) do
      { :missing, _ } ->
        Logger.debug "Failed to read from cache"
        urls = ["http://ad1.example.com/tag.js", "http://ad2.example.com/tag.js"]
        Cachex.set(:ad_cache, id, urls, [ ttl: :timer.seconds(10) ])
      { :ok, cache } ->
        Logger.debug "Read from cache"
        urls = cache
      _ ->
        # Unexpected error
        urls = []
    end

    json = Poison.encode!(%{"urls" => urls})
    render conn, "sample.js", json: json, callback: callback
  end
end
