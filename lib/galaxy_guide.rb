# frozen_string_literal: true
# Merchant's Guide to the Galaxy
class GalaxyGuide
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  # Handling invalid queries and finding the result
  def translate
    input_file = File.read(file_path).split("\n").map(&:downcase)
    input_array = input_file.map { |line| line.split(' is ') }
    input_hash = Hash[input_array]
    symbol_result = find_unknown_variable_from_input_hash(input_hash)
    input_hash.merge!(symbol_result)
    input_array.each do |question_variable|
      next unless question_variable.last&.include?('?')
      answer_invalid_queries(question_variable, input_hash)
    end
    'Thank you'
  end

  # Convertion logic for symbols and find the Sum
  def convert_to_numerals(symbols)
    sum = 0
    flag = 0
    symbols.each_char.with_index do |char, index|
      if flag == 1
        flag = 0
        next
      end
      symbol_values = ConvertHelper.fetch_symbol_values(char, index, symbols)
      sum, flag = ConvertHelper.calculate_sum(sum, flag, symbol_values)
    end
    sum
  end

  # find result from Roman numeral and credits
  def calculate_symbols(answer_value, question_variables)
    known_variables = question_variables[0..-2].join
    numeral = convert_to_numerals(known_variables)
    begin
      answer_value.split(' ').first.to_f / numeral
    rescue ZeroDivisionError
      logger.error('Cant divide using Zero!')
    end
  end

  # Find the variable's corresponding Roman numeral
  def list_question_symbols(question_key, input_hash)
    question_variables = []
    question_key.split(' ').each do |variable|
      var_class = input_hash[variable].class
      question_variables << if [NilClass, Float].include? var_class
                              variable
                            else
                              input_hash[variable].upcase
                            end
    end
    question_variables
  end

  # Finding the unknown variable in the invalid query
  def find_unknown_variable_from_input_hash(input_hash)
    unknown_symbols = {}
    input_hash.each do |question_key, answer_value|
      next unless ConvertHelper.no_iteration_required(answer_value)
      question_symbols = list_question_symbols(question_key, input_hash)
      unknown_variable = question_symbols.last
      numerals = calculate_symbols(answer_value, question_symbols)
      unknown_symbols.merge!(unknown_variable => numerals)
    end
    unknown_symbols
  end

  # Finding the result of invalid query with variables
  def find_variables_output(question_part, input_hash)
    all_variables = question_part.split(' ')[0..-1]
    symbols = all_variables.map { |sym| input_hash[sym] }.join
    answer = convert_to_numerals(symbols.upcase)
    puts "#{question_part}is #{answer}"
  end

  # Finding the credit score of invalid query
  def find_credit_score(question_part, input_hash)
    question_symbols = list_question_symbols(question_part, input_hash)
    symbols = question_symbols[0..-2].join
    numerals = convert_to_numerals(symbols)
    answer = numerals * input_hash[question_symbols.last]
    puts "#{question_part}is #{answer.to_i} Credits"
  end

  # Finding invalid query results
  def answer_invalid_queries(question_variable, input_hash)
    question_part = question_variable.last.chomp('?')
    if question_variable.include?('how much')
      find_variables_output(question_part, input_hash)
    elsif question_variable.include?('how many credits')
      find_credit_score(question_part, input_hash)
    else
      puts 'I have no idea what you are talking about'
    end
  end

  def logger
    Logger.new($stdout)
  end
end

require 'galaxy_guide/convert_helper'
