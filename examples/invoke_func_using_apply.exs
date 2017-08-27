defmodule Apple do
  def cool_func(name) do
    IO.puts "#{name} is red delicious!"
  end
end

defmodule Banana do
  def cool_func(name) do
    IO.puts "#{name} is soft and sweet!"
  end
end

for mod <- [Apple, Banana] do
  IO.puts mod
  apply(mod, :cool_func, ["Hannah"])
end
