# Custom Enumerable Project

This project is about recreating some commonly used enumerable methods:

- Array#each
- Enumerable#my_each_with_index
- Enumerable#select
- Enumerable#all?
- Enumerable#any?
- Enumerable#none?
- Enumerable#count
- Enumerable#map
- Enumerable#inject

The recreated methods will be prefixed with 'my_'.

The methods can be tested with the following command:
- `bundle exec rspec spec/my_each_spec.rb`
- `bundle exec rspec spec/my_each_with_index_spec.rb`
- `bundle exec rspec spec/my_select_spec.rb`
- `bundle exec rspec spec/my_all_spec.rb`
- `bundle exec rspec spec/my_any_spec.rb`
- `bundle exec rspec spec/my_none_spec.rb`
- `bundle exec rspec spec/my_count_spec.rb`
- `bundle exec rspec spec/my_map_spec.rb`
- `bundle exec rspec spec/my_inject_spec.rb`