
failed = false

function failTest(msg)
    msg = msg or ""
    printh(msg)
    failed = true
end

function checkEquals(a, b) -- TODO inline?
    return a == b
end

function check_failure(result, msg)
    if not result then
        failed = true
        printh(msg)
    end
end

asserts = {} -- Assert functions should take whatever args they need, and return two -- the result as a boolean, and a failure message.

function asserts.equals(a, b, failMsg)
    return checkEquals(a, b), "assertEquals failure: "..tostr(a).." != "..tostr(b)..": "..tostr(failMsg)
end

function asserts.notEquals(a, b, failMsg)
    return not asserts.equals(a, b), "assertNotEquals failure: "..tostr(a).." == "..tostr(b)..": "..tostr(failMsg)
end

assert_runner = {}
assert_runner.__index = function (tbl, key)
    return function (...)
        runtest(asserts[key], ...)
    end
end

assert = {}
setmetatable(assert, assert_runner)

function runtest(fn, ...)
    local result, msg = fn(...)
    check_failure(result, msg)
end

test = {}

function test.example_test()
    assert.equals(true, true)
    assert.equals(true, false, "Expected failure")
end

function test.example_test2()
    assert.notEquals(true, false) -- TODO should this be assert.not.equals(true, false)? But then how would we make the message sane?
    assert.notEquals(true, true, "Expected failure 2")
end

function runTests()
    -- TODO test discovery
    printh("")
    printh("Running example_test()...")
    test.example_test()
    printh("")
    printh("Running example_test2()...")
    test.example_test2()
    printh("")
    printh("Done running tests")
    printh("")

    if failed then
        printh("Fail")
    else
        -- The Makefile recognizes success by whether or not the very last line of output includes the text "Pass".
        printh("Pass")
    end
end

runTests()