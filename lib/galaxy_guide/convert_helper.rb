class GalaxyGuide::ConvertHelper

  # Iterate input hash based on this condition
  def self.no_iteration_required(answer_value)
    condition1 = (answer_value&.is_a? String) || answer_value&.include?('?')
    answer_count = answer_value&.split(' ')&.count
    condition2 = answer_value&.include?('credits') && answer_count == 2
    condition1 && condition2
  end

  # Calculating the sum of mapped numerals
  def self.calculate_sum(sum, flag, symbol_values)
    numerals = symbol_values.first
    sum += if numerals[0] >= numerals[1]
             numerals[0]
           else
             flag = 1
             (numerals[1] - numerals[0])
           end
    [sum, flag]
  end

  def self.fetch_symbol_values(char, index, symbols)
    first_val = symbol_value_mapping[char]
    next_val = symbol_value_mapping[symbols[index + 1..index + 1]].to_i
    { first_val => next_val }
  end

  # Translation between Roman numerals and numbers
  def self.symbol_value_mapping
    {
      'I' => 1,
      'V' => 5,
      'X' => 10,
      'L' => 50,
      'C' => 100,
      'D' => 500,
      'M' => 1000
    }
  end

  
end
