defmodule PhoenixSampleAdApp.PageController do
  use PhoenixSampleAdApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
