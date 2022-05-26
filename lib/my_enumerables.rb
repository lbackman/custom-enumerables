# frozen_string_literal: true

# Recreating enumerables
module Enumerable
  def my_each_with_index
    return to_enum(__method__) { size if size } unless block_given?

    idx = 0
    my_each do |el|
      yield(el, idx)
      idx += 1
    end
    self
  end

  def my_select
    return to_enum(__method__) { size if size } unless block_given?

    selected = []
    my_each { |el| selected << el if yield(el) }
    selected
  end

  def my_all?
    false_count = 0
    unless block_given?
      return true if size.zero?

      my_each do |el|
        false_count += 1 unless el
        return false if false_count.positive?
      end

      return true
    end
    my_each do |el| 
      false_count += 1 unless yield(el)
      return false if false_count.positive?
    end

    true
  end

  def my_any?
    true_count = 0
    unless block_given?
      return false if size.zero?

      my_each do |el|
        true_count += 1 if el
        return true if true_count.positive?
      end

      return false
    end
    my_each do |el|
      true_count += 1 if yield(el)
      return true if true_count.positive?
    end

    false
  end

  def my_none?
    true_count = 0
    unless block_given?
      return true if size.zero?

      my_each do |el|
        true_count += 1 if el
        return false if true_count.positive?
      end

      return true
    end
    my_each do |el|
      true_count += 1 if yield(el)
      return false if true_count.positive?
    end

    true
  end

  def my_count
    return size unless block_given?

    counted = 0
    my_each { |el| counted += 1 if yield(el) }
    counted
  end

  def my_map
    return to_enum(__method__) { size if size } unless block_given?

    mapped = []
    my_each { |el| mapped << yield(el) }
    mapped
  end

  def my_inject(*args)
    unless block_given?
      case args.size
      when 1
        sym = args.first
        accumulator = shift
      when 2
        accumulator = args.first
        sym = args.last
      end
      my_each { |el| accumulator = accumulator.send(sym, el) }
      return accumulator
    end
    case args.size
    when 0 then accumulator = shift
    when 1 then accumulator = args.first
    end
    my_each { |el| accumulator = yield(accumulator, el) }
    accumulator
  end
end

# Need my_each for use in module Enumerables
class Array
  def my_each
    return to_enum(__method__) { size if size } unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end
end
