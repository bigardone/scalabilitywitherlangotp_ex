defmodule ScalabilitywitherlangotpEx.Ch4.Timeout do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch4/timeout.erl
  """

  ######################
  # CALLBACK FUNCTIONS #
  ######################

  def init(_args), do: {:ok, :undefined}

  def handle_call({:sleep, ms}, _from, loop_data) do
    Process.sleep(ms)

    {:reply, :ok, loop_data}
  end
end
