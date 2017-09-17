defmodule ScalabilitywitherlangotpEx.Ch4.From do
  @moduledoc """
  Sends an early response to the caller before doing expensive
  data management

  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch4/from.erl
  """

  use GenServer

  ######################
  # CALLBACK FUNCTIONS #
  ######################

  def init(sum) do
    {:ok, sum}
  end

  def handle_call({:add, data}, from, sum) do
    GenServer.reply(from, :ok)

    Process.sleep(1_000)

    new_sum = add(data, sum)
    :io.format("From:~p, Sum:~p~n", [from, new_sum])

    {:noreply, new_sum}
  end

  defp add(data, sum), do: data + sum
end
