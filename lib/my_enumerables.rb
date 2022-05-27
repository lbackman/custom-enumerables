# frozen_string_literal: true

# Recreating enumerables
module Enumerable
  def my_each_with_index
    # The size block ensures that calling Enumerator#size works as expected.
    return to_enum(__method__) { size } unless block_given?

    idx = 0
    my_each do |el|
      yield(el, idx)
      idx += 1
    end
    self
  end

  def my_select
    return to_enum(__method__) { size } unless block_given?

    selected = []
    my_each { |el| selected << el if yield(el) }
    selected
  end

  def my_all?
    unless block_given?
      my_each { |el| return false unless el }

      return true
    end
    my_each { |el| return false unless yield(el) }

    true
  end

  def my_any?
    unless block_given?
      my_each { |el| return true if el }

      return false
    end
    my_each { |el| return true if yield(el) }

    false
  end

  # The opposite of at least 1 (or any) is none.
  def my_none?(&block)
    !my_any?(&block)
  end

  def my_count(item = omitted = true)
    return size if omitted && !block_given?

    counted = 0
    if !omitted
      warn('warning: block not used') if block_given?

      my_each { |el| counted += 1 if item === el }
    elsif block_given?
      my_each { |el| counted += 1 if yield(el) }
    end
    counted
  end

  def my_map
    return to_enum(__method__) { size } unless block_given?

    mapped = []
    my_each { |el| mapped << yield(el) }
    mapped
  end

  def my_inject(*args, &block)
    return my_inject_no_block(self, *args) unless block_given?

    my_inject_block(self, *args, &block)
  end

  private

  def my_inject_no_block(obj, *args)
    case args.size
    when 1
      sym = args.first
      accumulator = obj.shift
    when 2
      accumulator = args.first
      sym = args.last
    end
    obj.my_each { |el| accumulator = accumulator.send(sym, el) }
    accumulator
  end

  def my_inject_block(obj, *args)
    case args.size
    when 0 then accumulator = obj.shift
    when 1 then accumulator = args.first
    end
    obj.my_each { |el| accumulator = yield(accumulator, el) }
    accumulator
  end
end

# Need my_each for use in module Enumerables
class Array
  def my_each
    return to_enum(__method__) { size } unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end
end
