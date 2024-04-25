lua_framework_tests = {}

function lua_framework_tests.test_str_find_char()
    assert.equals(1, str_find_char("asdf", "a"))
    assert.equals(2, str_find_char("asdf", "s"))
    assert.equals(4, str_find_char("asdf", "f"))
    assert.equals(nil, str_find_char("asdf", "x"))
end

function verify_reverse(expected, input)
    reverse_table(input)
    assert.dumpEquals(expected, input)
end

function lua_framework_tests.test_reverse_table()
    verify_reverse({}, {})
    verify_reverse({1}, {1})
    verify_reverse({2, 1}, {1, 2})
    verify_reverse({3, 2, 1}, {1, 2, 3})
    verify_reverse({4, 3, 2, 1}, {1, 2, 3, 4})
end

function lua_framework_tests.test_full_tostr()
    assert.equals("0", full_tostr(0))
    assert.equals("1", full_tostr(1))
    assert.equals("-1", full_tostr(-1))
    assert.equals("32767", full_tostr(32767))
    assert.equals("-32767", full_tostr(-32767))
    assert.equals("-32768", full_tostr(32768))
    assert.equals("0.25", full_tostr(0.25))
    assert.equals("0.0999908447265625", full_tostr(0.1))
    assert.equals("0.0000152587890625", full_tostr(1 >> 16))
    assert.equals("32767", full_tostr(0b111111111111111))
    assert.equals("32767.9999847412109375", full_tostr(0b111111111111111.1111111111111111))

end

runTests("Lua framework tests", lua_framework_tests)