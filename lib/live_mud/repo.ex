defmodule LiveMud.Repo do
  use Ecto.Repo,
    otp_app: :live_mud,
    adapter: Ecto.Adapters.Postgres
end
