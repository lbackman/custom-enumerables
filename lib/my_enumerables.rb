# frozen_string_literal: true

# The follwing methods will be recreated:
# - Array#each
# - Enumerable#each_with_index
# - Enumerable#select
# - Enumerable#all?
# - Enumerable#any?
# - Enumerable#none?
# - Enumerable#count
# - Enumerable#map
# - Enumerable#inject

module Enumerable
  def my_each_with_index
    return self.to_enum(__method__) { size if size } unless block_given?

    i = 0
    while i < self.size
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return self.to_enum(__method__) { size if size } unless block_given?

    selected = []
    self.my_each { |el| selected << el if yield(el) }
    selected
  end

  def my_all?
    unless block_given?
      return true if self.size == 0

      true_arr = []
      self.my_each { |el| true_arr << el if el }
      return true if true_arr.size == self.size

      return false
    end
    true_arr = []
    self.my_each { |el| true_arr << yield(el) if yield(el) }
    return true if true_arr.size == self.size

    false
  end

  def my_any?
    unless block_given?
      return false if self.size == 0

      true_count = 0
      self.my_each { |el| true_count += 1 if el }
      return true if true_count > 0

      return false
    end
    true_count = 0
    self.my_each { |el| true_count += 1 if yield(el) }
    return true if true_count > 0

    false
  end

  # For my_none? I tried making it so that immedately when
  # there is a truthy value, the method will return false.
  def my_none?
    unless block_given?
      return true if self.size == 0

      true_arr = []
      self.my_each do |el|
        true_arr << el if el
        return false if true_arr.size > 0
      end
      return true
    end
    true_arr = []
    self.my_each do |el|
      true_arr << yield(el) if yield(el)
      return false if true_arr.size > 0
    end
    true
  end

  def my_count
    return self.size unless block_given?

    counted = 0
    self.my_each { |el| counted += 1 if yield(el) }
    counted
  end

  def my_map
    return self.to_enum(__method__) { size if size } unless block_given?

    mapped = []
    self.my_each { |el| mapped << yield(el) }
    mapped
  end

  def my_inject(*args)
    unless block_given?
      case args.size
      when 1
        sym = args.first
        accumulator = self.shift
      when 2
        accumulator = args.first
        sym = args.last
      end
      self.my_each { |el| accumulator = accumulator.send(sym, el) }
      return accumulator
    end
    case args.size
    when 0
      accumulator = self.shift
    when 1
      accumulator = args.first
    end
    self.my_each { |el| accumulator = yield(accumulator, el) }
    accumulator
  end
end

class Array
  def my_each
    return self.to_enum(__method__) { size if size } unless block_given?
    
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
    end
    self
  end
end
