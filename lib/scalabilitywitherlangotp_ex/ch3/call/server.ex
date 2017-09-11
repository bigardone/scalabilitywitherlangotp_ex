defmodule ScalabilitywitherlangotpEx.Ch3.Call.Server do
  @moduledoc nil

  def start(name, args) do
    __MODULE__
    |> spawn(:init, [name, args])
    |> Process.register(name)
  end

  def stop(name) do
    send(name, {:stop, self()})

    receive do
      {:reply, reply} -> reply
    end
  end

  def init(mod, args) do
    state = mod.init(args)

    loop(mod, state)
  end

  def call(name, msg) do
    ref = Process.monitor(name)

    send(name, {:request, {ref, self()}, msg})

    receive do
      {:reply, ^ref, response} ->
        Process.demonitor(ref, :flush)
        response

      {'DOWN', ^ref, :process, _name, _reason} ->
        {:error, :no_proc}
    end
  end

  defp reply({ref, to}, response) do
    send(to, {:reply, ref, response})
  end

  defp loop(mod, state) do
    receive do
      {:request, from, msg} ->
        {new_state, response} = mod.handle(msg, state)
        reply(from, response)
        loop(mod, new_state)

      {:stop, from} ->
        response = mod.terminate(state)
        send(from, {:reply, response})
    end
  end
end
