greetings = """
Hello World
Hallo Welt
你好世界
こんにちは世界
Saluton mondo
"""
|> String.trim()
|> String.split("\n")

# IO.inspect greetings

for _ <- 1..10 do
  IO.puts Enum.random(greetings)
end
