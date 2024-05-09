asserts = {} -- Assert functions should take whatever args they need, and return two -- the result as a boolean, and a failure message.

-- Functions here are implemented as "asserts.*" but invoked as "assert.*" so the framework can inject its code.
-- See test_framework.lua.

function asserts.fail(failMsg)
    return false, "asserts.fail: "..tostr(failMsg)
end

function asserts.isTrue(a, failMsg)
    return a, "asserts.isTrue failure: expected "..dump(a).." to be true: "..tostr(failMsg)
end

function asserts.isFalse(a, failMsg)
    return not asserts.isTrue(a), "asserts.isFalse failure: expected "..dump(a).." to not be true: "..tostr(failMsg)
end

function asserts.equals(a, b, failMsg)
    return a == b, "asserts.equals failure: "..dump(a).." != "..dump(b)..": "..tostr(failMsg)
end

function asserts.dumpEquals(a, b, failMsg)
    return asserts.equals(dump(a), dump(b), failMsg)
end

function asserts.notEquals(a, b, failMsg)
    return not asserts.equals(a, b), "asserts.notEquals failure: "..dump(a).." == "..dump(b)..": "..tostr(failMsg)
end
