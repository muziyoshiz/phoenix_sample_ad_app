defmodule PhoenixSampleAdApp.Router do
  use PhoenixSampleAdApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixSampleAdApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PhoenixSampleAdApp do
    pipe_through :api

    get "/sample1.js", ApiController, :sample1
    get "/sample2.js", ApiController, :sample2
    get "/sample3.js", ApiController, :sample3
    get "/sample4.js", ApiController, :sample4
    get "/sample5.js", ApiController, :sample5
  end
end
