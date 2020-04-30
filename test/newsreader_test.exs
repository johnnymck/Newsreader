defmodule NewsreaderTest do
  use ExUnit.Case
  doctest Newsreader

  test "greets the world" do
    assert Newsreader.hello() == :world
  end
end
