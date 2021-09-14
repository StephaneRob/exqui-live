defmodule ExquiLive.Router do
  defmacro exqui_live(path) do
    quote bind_quoted: binding() do
      import Phoenix.LiveView.Router

      scope path do
        import Phoenix.LiveView.Router, only: [live: 4, live_session: 3]

        live_session :exqui_live, root_layout: {ExquiLive.LayoutView, :exq} do
          live "/", ExquiLive.HomeLive, :home, as: :exqui_live
        end
      end
    end
  end
end
