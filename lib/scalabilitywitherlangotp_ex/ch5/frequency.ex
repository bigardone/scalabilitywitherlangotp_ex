defmodule ScalabilitywitherlangotpEx.Ch5.Frequency do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch5/frequency.erl
  """
  use GenServer

  ####################
  # CLIENT FUNCTIONS #
  ####################

  @doc """
  Starts the frequency server. Called by supervisor
  """
  def start do
    GenServer.start_link(__MODULE__, [], name: :frequency)
  end

  @doc """
  Stops the frequency server
  """
  def stop do
    GenServer.cast(:frequency, :stop)
  end

  @doc """
  If available, it returns a frequency used to make a call.
  Frequency must be deallocated on termination.
  """
  def allocate do
    GenServer.call(:frequency, {:allocate, self()})
  end

  @doc """
  Frees a frequency so it can be used by another client
  """
  def deallocate(frequency) do
    GenServer.cast(:frequency, {:deallocate, frequency})
  end

  ######################
  # CALLBACK FUNCTIONS #
  ######################

  @doc """
  Initialises the generic server by getting the list of
  available frequencies. [] is the list of allocated ones
  """
  def init(_args) do
    frequencies = {get_frequencies(), []}

    {:ok, frequencies}
  end

  def handle_call({:allocate, pid}, _from, frequencies) do
    {new_frequencies, reply} = allocate(frequencies, pid)

    {:reply, reply, new_frequencies}
  end

  def handle_cast({:deallocate, freq}, frequencies) do
    new_frequencies = deallocate(frequencies, freq)

    {:noreply, new_frequencies}
  end

  def handle_cast(:stop, frequencies), do: {:stop, :normal, frequencies}

  def handle_info(_msg, frequencies), do: {:noreply, frequencies}

  # Termination callback. Does nothing, but should instead kill clients
  def terminate(_reason, _frequencies), do: :ok

  def format_status(_opt, [_pro_dict, {available, allocated}]) do
    {:data, [{"State", {{:available, available}, {:allocated, allocated}}}]}
  end

  ######################
  # INTERNAL FUNCTIONS #
  ######################

  defp get_frequencies, do: [10, 11, 12, 13, 14, 15]

  defp allocate({[], allocated}, _pid) do
    {{[], allocated}, {:error, :no_frequency}}
  end
  defp allocate({[res | resouces], allocated}, pid) do
    {{resouces, [{res, pid} | allocated]}, {:ok, res}}
  end

  defp deallocate({free, allocated}, res) do
    new_allocated = List.keydelete(allocated, res, 0)

    {[res | free], new_allocated}
  end
end
