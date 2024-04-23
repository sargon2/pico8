lua_framework_tests = {}

function lua_framework_tests.test_str_find_char()
    assert.equals(1, str_find_char("asdf", "a"))
    assert.equals(2, str_find_char("asdf", "s"))
    assert.equals(4, str_find_char("asdf", "f"))
    assert.equals(nil, str_find_char("asdf", "x"))
end

runTests("Lua framework tests", lua_framework_tests)