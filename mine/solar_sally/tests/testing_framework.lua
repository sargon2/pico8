
failed = false
num_failed = 0

assert_runner = {}
assert_runner.__index = function (tbl, key)
    return function (...)
        local result, msg = asserts[key](...)
        if not result then
            failed = true
            num_failed += 1
            printh(msg)
            printh(trace())
        end
    end
end

assert = {}
setmetatable(assert, assert_runner)

function runTests(name, test_class)
    printh("Running suite \""..tostr(name).."\"...")
    for k, v in pairs(test_class) do
        if type(v) == "function" then
            printh("    Running test "..tostr(k).."()...")
            v()
        end
    end
end

function reportResults()
    if failed then
        printh("Fail; "..tostr(num_failed).." tests failed")
    else
        -- The Makefile recognizes success by whether or not the very last line of output includes the text "Pass".
        printh("Pass")
    end
end
