defmodule ScalabilitywitherlangotpEx.Ch3.Frequency do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch3/frequency.erl
  """

  @doc """
  Create the server
  """
  def start do
    __MODULE__
    |> spawn(:init, [])
    |> Process.register(:frequency)
  end

  @doc """
  Inits the server
  """
  def init do
    frequencies = {get_frequencies(), []}

    loop(frequencies)
  end

  @doc """
  Finishes the process loop
  """
  def stop, do: call(:stop)

  @doc """
  Tries to allocate a free frequency
  """
  def allocate, do: call(:allocate)

  @doc """
  Frees a frequency
  """
  def deallocate(frequency), do: call({:deallocate, frequency})

  defp call(message) do
    send(:frequency, {:request, self(), message})

    receive do
      {:reply, response} ->
        response
    end
  end

  defp reply(pid, response), do: send(pid, {:reply, response})

  defp loop(frequencies) do
    receive do
      {:request, pid, :allocate} ->
        {new_frequencies, reply} = allocate(frequencies, pid)
        reply(pid, reply)
        loop(new_frequencies)

      {:request, pid, {:deallocate, frequency}} ->
        new_frequencies = deallocate(frequencies, frequency)
        reply(pid, :ok)
        loop(new_frequencies)

      {:request, pid, :stop} ->
        reply(pid, :ok)
    end
  end

  defp get_frequencies, do: [10, 11, 12, 13, 14, 15]

  defp allocate({[], _allocated} = params, _pid), do: {params, {:error, :no_frequency}}
  defp allocate({[frequency | free], allocated}, pid) do
    {{free, [{frequency, pid} | allocated]}, {:ok, frequency}}
  end

  defp deallocate({free, allocated}, frequency) do
    new_allocated = List.keydelete(allocated, frequency, 1)

    {[frequency | free], new_allocated}
  end
end
