defmodule Ds18b20.Reader do
   use GenServer

   def start_link() do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
   end

   def init(_) do
      Task.start_link(fn -> loop end)
   end

   defp loop do
      base_dir = "/sys/bus/w1/devices/"

      File.ls!(base_dir)
      |> Enum.filter(&(String.starts_with?(&1, "28-")))
      |> get_temp(base_dir)

      :timer.sleep(1000)
      loop
   end

   defp get_temp(sensor, base_dir) do
      sensor_data = IO.puts base_dir <> sensor <> "/w1_slave" |> File.read!
      [_, temp] = Regex.run(~r/t=(\d+)/, sensor_data)
      IO.puts temp
   end
end
