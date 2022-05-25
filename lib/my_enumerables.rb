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
