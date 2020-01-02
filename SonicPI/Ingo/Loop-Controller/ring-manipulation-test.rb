# ring-manipulation-test.rb
set :q, (ring 1, 2, 3, 4, 5, 6, 7, 8, 9, 0)
print get[:q]

old_q = get[:q]
puts old_q.frozen?

new_q = old_q.put(4, 0)

assert_equal old_q, (ring 1, 2, 3, 4, 5, 6, 7, 8, 9, 0)
assert_equal new_q, (ring 1, 2, 3, 4, 0, 6, 7, 8, 9, 0)

set :q, new_q
print get[:q]
