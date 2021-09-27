Application.put_env(:exqui_live, ExquiLiveTest.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  check_origin: false,
  pubsub_server: ExquiLiveTest.PubSub
)

defmodule ExquiLiveTest.Router do
  use Phoenix.Router
  import ExquiLive.Router

  pipeline :browser do
    plug :fetch_session
  end

  scope "/" do
    pipe_through :browser

    exqui_live("/exqui")
  end
end

defmodule ExquiLiveTest.Endpoint do
  use Phoenix.Endpoint, otp_app: :exqui_live

  plug Plug.Session,
    store: :cookie,
    key: "_live_view_key",
    signing_salt: "/VEDsdfsffMnp5"

  plug ExquiLiveTest.Router
end

Supervisor.start_link(
  [
    {Phoenix.PubSub, name: ExquiLiveTest.PubSub, adapter: Phoenix.PubSub.PG2},
    ExquiLiveTest.Endpoint
  ],
  strategy: :one_for_one
)

ExUnit.start()
