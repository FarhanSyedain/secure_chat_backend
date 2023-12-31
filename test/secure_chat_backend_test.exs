defmodule SecureChatBackendTest do
  use ExUnit.Case
  doctest SecureChatBackend

  test "greets the world" do
    assert SecureChatBackend.hello() == :world
  end
end
