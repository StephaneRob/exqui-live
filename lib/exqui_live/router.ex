defmodule ExquiLive.Router do
  defmacro exqui_live(path) do
    quote bind_quoted: binding() do
      import Phoenix.LiveView.Router

      scope path do
        import Phoenix.LiveView.Router, only: [live: 4, live_session: 3]

        live_session :exqui_live, root_layout: {ExquiLive.LayoutView, :exq} do
          live "/failed/:jid", ExquiLive.FailedLive, :failed, as: :exqui_live
          live "/failed", ExquiLive.AllFailedLive, :all_failed, as: :exqui_live
          live "/queues/:name", ExquiLive.QueueLive, :queue, as: :exqui_live
          live "/queues", ExquiLive.QueuesLive, :queues, as: :exqui_live
          live "/retries", ExquiLive.RetriesLive, :retries, as: :exqui_live
          live "/scheduled", ExquiLive.ScheduledLive, :scheduled, as: :exqui_live
          live "/", ExquiLive.HomeLive, :home, as: :exqui_live
        end
      end
    end
  end
end
