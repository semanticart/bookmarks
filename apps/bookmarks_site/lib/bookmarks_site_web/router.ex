defmodule BookmarksSiteWeb.Router do
  use BookmarksSiteWeb, :router

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

  scope "/", BookmarksSiteWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # TODO: this should live elsewhere
    get "/tags/:tag", PageController, :tag
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookmarksSiteWeb do
  #   pipe_through :api
  # end
end
