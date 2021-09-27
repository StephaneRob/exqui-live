defmodule ExquiLive.Helper do
  # General helpers for live views (not-rendering related).
  @moduledoc false

  @doc """
  Computes a route path to the live dashboard.
  """
  def exqui_live_path(socket, action, params) do
    apply(
      socket.router.__helpers__(),
      :exqui_live_path,
      [socket, action, params]
    )
  end

  def exqui_live_path(socket, action) do
    apply(
      socket.router.__helpers__(),
      :exqui_live_path,
      [socket, action]
    )
  end

  def map_jid_to_id(jobs) when is_list(jobs) do
    for job <- jobs do
      map_jid_to_id(job)
    end
  end

  def map_jid_to_id(job), do: Map.put(job, :id, job.jid)

  def score_to_time(score) when is_float(score) do
    round(score * 1_000_000)
    |> DateTime.from_unix!(:microsecond)
    |> DateTime.to_iso8601()
  end

  def score_to_time(score) do
    if String.contains?(score, ".") do
      score_to_time(String.to_float(score))
    else
      String.to_integer(score)
      |> DateTime.from_unix!()
      |> DateTime.to_iso8601()
    end
  end

  def map_score_to_jobs(jobs) do
    Enum.map(jobs, fn {job, score} ->
      job
      |> Map.put(:scheduled_at, score_to_time(score))
      |> Map.put(:id, job.jid)
    end)
  end

  def convert_results_to_times(jobs, score_key) when is_list(jobs) do
    for job <- jobs do
      convert_results_to_times(job, score_key)
    end
  end

  def convert_results_to_times(job, score_key) do
    Map.put(job, score_key, score_to_time(Map.get(job, score_key)))
  end

  def schedule_update(socket) do
    refresh =
      if Map.has_key?(socket.assigns, :refresh) do
        socket.assigns.refresh
      else
        2
      end

    if refresh, do: Process.send_after(self(), :update, refresh * 1000)
  end
end
