require 'minitest/autorun'
require 'galaxy_guide'

class GalaxyGuideTest < Minitest::Test
  def test_translate
    assert_equal 'Thank you',
      GalaxyGuide.new('tmp/test_input.txt').translate
  end

  def test_convert_to_numerals_case1
    assert_equal 2006,
      GalaxyGuide.new('tmp/test_input.txt').convert_to_numerals('MMVI')
  end

  def test_convert_to_numerals_case2
    assert_equal 1903,
    GalaxyGuide.new('tmp/test_input.txt').convert_to_numerals('MCMIII')
  end

  def test_list_question_symbols
    assert_equal ["I", "I", "silver"],
    GalaxyGuide.new('tmp/test_input.txt').list_question_symbols("glob glob silver", { "glob"=>"i" })
  end

  def test_calculate_symbols
    assert_equal 17.0,
    GalaxyGuide.new('tmp/test_input.txt').calculate_symbols("34 credits", ["I", "I", "silver"])
  end

  def test_find_unknown_variable_from_input_hash
    output = {"silver"=>17.0}
    input_hash = {"glob"=>"i", "glob glob silver"=>"34 credits"}
    assert_equal output,
    GalaxyGuide.new('tmp/test_input.txt').find_unknown_variable_from_input_hash(input_hash)
  end  
end
