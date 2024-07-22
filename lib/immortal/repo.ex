defmodule Immortal.Repo do
  use Ecto.Repo,
    otp_app: :immortal,
    adapter: Ecto.Adapters.Postgres
end
