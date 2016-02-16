defmodule KidcoinApi.Router do
  use KidcoinApi.Web, :router

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

  scope "/", KidcoinApi do
    pipe_through :browser # Use the default browser stack

    get "/", ElmController, :app
    get "/login", ElmController, :app
    get "/register", ElmController, :app
  end

  # Other scopes may use custom stacks.
  scope "/api", KidcoinApi do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/households", HouseholdController, except: [:new, :edit]
    resources "/transactions", TransactionController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end
end
