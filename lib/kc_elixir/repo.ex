defmodule KcElixir.Repo do
  use Ecto.Repo,
    otp_app: :kc_elixir,
    adapter: Ecto.Adapters.Postgres
end
