defmodule LiveMudWeb.Router do
  use LiveMudWeb, :router

  import LiveMudWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveMudWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveMudWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_mud, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveMudWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LiveMudWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LiveMudWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LiveMudWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LiveMudWeb.UserAuth, :ensure_authenticated}] do

      # Settings
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      # Characters
      live "/characters", CharacterLive.Index, :index
      live "/characters/new", CharacterLive.Index, :new
      live "/characters/:id/edit", CharacterLive.Index, :edit
      live "/characters/:id", CharacterLive.Show, :show
      live "/characters/:id/show/edit", CharacterLive.Show, :edit

      # Room Timeline
      live "/room", RoomLive.Timeline, :index
    end
  end

  scope "/", LiveMudWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LiveMudWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
