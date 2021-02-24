defmodule Bulls.Game do
  @moduledoc """
  Does computations for a game of Bulls and Cows. Built base from the following
  lecture code: https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/07-phoenix/notes.md
  """

  @type guess_display :: {
          # sets type guess to type string
          guess :: String.t(),
          a :: non_neg_integer,
          b :: non_neg_integer
        }
  @type(state :: guesses :: [String.t()], {secret :: String.t()})

  def new do
    %{
      # MapSet is from lecture, can contain unique elements of any kind, no particular order
      guesses: MapSet.new(),
      secret: makeSecret(),
      error: ""
    }
  end

  # need to rethink makeSecret since we no longer have while loops, loose types, etc...
  def makeSecret do
    firstNum = Enum.take_random(1..9, 1)
    remainingNum = Enum.take_random(0..9, 3)
    secret = Enum.concat(firstNum, remainingNum) |> Enum.join()
    secret
  end

  def checkUnique(guess) do
    guessAsSet = MapSet.new(guess)
    MapSet.size(guessAsSet) > 3
  end

  def guess(st, num) do
    # graphemes was discovered from lecture, very useful!
    num_digits = String.graphemes(num)

    cond do
      !checkUnique(num_digits) ->
        # Enum.uniq(num_digits) != num_digits ->
        %{st | error: "no duplicates allowed"}

      # https://hexdocs.pm/elixir/Regex.html and https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
      Regex.match?(~r/^[1-9]/, num) ->
        %{st | guesses: MapSet.put(st.guesses, num), error: ""}
    end
  end

  def outOfGuesses?(st) do
    MapSet.size(st.guesses) >= 8
  end

  def isCorrectGuess?(st) do
    Enum.member?(st.guesses, st.secret)
  end

  # needed help with guesses and used https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
  # to reference capture operator
  def view(st) do
    # if we correctly guess the secret, change to true so we render win view!
    success = isCorrectGuess?(st)

    %{
      guesses: Enum.map(st.guesses, &display_guess(&1, st.secret)),
      won: success,
      # if we run out of guesses and success is equal to false, (just in case
      lost: not success and outOfGuesses?(st)
      # they run out of guesses on the last turn)
    }
  end

  def display_guess(guess, secret) do
    guess_by_digit = String.graphemes(guess)
    secret_by_digit = String.graphemes(secret)

    # https://hexdocs.pm/elixir/Enum.html#zip/2
    Enum.zip(secret_by_digit, guess_by_digit)
    |> Enum.reduce(%{a: 0, b: 0}, fn {s, g}, %{a: bulls, b: cows} ->
      cond do
        String.equivalent?(s, g) -> %{a: bulls + 1, b: cows}
        Enum.member?(secret_by_digit, g) -> %{a: bulls, b: cows + 1}
        true -> %{a: bulls, b: cows}
      end
    end)
    |> Map.put(:guess, guess)
  end
end
