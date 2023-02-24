# frozen_string_literal: true

require "test_helper"

class TestAutomatic1111 < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Automatic1111::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
