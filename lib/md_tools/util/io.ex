defmodule MdTools.Util.IO do

  def puts(text) do
    unless Mix.env() == :test do
      IO.puts(text)
    end
  end

end
