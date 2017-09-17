defmodule ScalabilitywitherlangotpEx.Ch4.Ping do
  @moduledoc """
  Handles `:timeout` message every `@timeout` milliseconds after handling the `:start` message.
  Handling `:pause` message removes the timeout call.

  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch4/ping.erl
  """

  use GenServer

  @timeout 5_000

  ######################
  # CALLBACK FUNCTIONS #
  ######################

  def init(_args) do
    {:ok, :undefined, @timeout}
  end

  def handle_call(:start, _from, loop_data) do
    {:reply, :started, loop_data, @timeout}
  end
  def handle_call(:pause, _from, loop_data) do
    {:reply, :paused, loop_data}
  end

  def handle_info(:timeout, loop_data) do
    {_hour, _min, sec} = Time.to_erl(Time.utc_now())
    :io.format("~2.w~n", [sec])

    {:noreply, loop_data, @timeout}
  end
end
