defmodule CliTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  import PeIssues.CLI, only: [
                               parse_args: 1,
                               sort_into_ascending_order: 1,
                               convert_to_list_of_hashdicts: 1,
                               decode_response: 1
                             ]
  doctest PeIssues.CLI

  # process(:help)
  test ":help returned by option parsing with -h option" do
    assert parse_args([ "-h", "anything" ]) == :help
  end

  # process(:help)
  test ":help returned by option parsing with --help option" do
    assert parse_args([ "--help", "anything" ]) == :help
  end

  # process({ user, project, count })
  test "three values returned if three given" do
    assert parse_args([ "user", "project", "99" ]) == { "user", "project", 99 }
  end

  # process({ user, project, count })
  test "count is defaulted if two values given" do
    assert parse_args([ "user", "project" ]) == { "user", "project", 4 }
  end

  # sort_into_ascending_order(list_of_issues)
  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end

  # decode_response({ :ok, body })
  test "decoding an :ok response returns the body" do
    context = { :ok, "expected_output" }
    assert decode_response(context) == "expected_output"
  end

  # Helpers
  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "xxx"} ]
    convert_to_list_of_hashdicts data
  end
end
