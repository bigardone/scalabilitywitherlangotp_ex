defmodule ScalabilitywitherlangotpEx.Ch3.Behavior.Frequency do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch3/behavior/frequency.erl
  """

  alias ScalabilitywitherlangotpEx.Ch3.Behavior.Server

  @doc """
  Starts the server
  """
  def start, do: Server.start(__MODULE__, [])

  @doc """
  Initializes the server
  """
  def init(_args), do: {get_frequencies(), []}

  def stop, do: Server.stop(__MODULE__)

  def allocate, do: Server.call(__MODULE__, {:allocate, self()})

  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})

  def handle({:allocate, pid}, frequencies), do: allocate(frequencies, pid)
  def handle({:deallocate, freq}, frequencies), do: {deallocate(frequencies, freq), :ok}

  def terminate(_frequencies), do: :ok

  defp get_frequencies, do: [10, 11, 12, 13, 14, 15]

  # The internal helper functions  used to allocate and
  # deallocate frequencies
  def allocate({[], allocated}, _pid) do
    {{[], allocated}, {:error, :no_frequency}}
  end
  def allocate({[freq | free], allocated}, pid) do
    {{free, [{freq, pid} | allocated]}, {:ok, freq}}
  end

  def deallocate({free, allocated}, freq) do
    new_allocated = List.keydelete(allocated, freq, 1)

    {[freq | free], new_allocated}
  end
end
