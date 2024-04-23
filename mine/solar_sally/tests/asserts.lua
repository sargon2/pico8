asserts = {} -- Assert functions should take whatever args they need, and return two -- the result as a boolean, and a failure message.

function asserts.isTrue(a, failMsg)
    return a, "asserts.isTrue failure: expected "..tostr(a).." to be true: "..tostr(failMsg)
end

function asserts.isFalse(a, failMsg)
    return not asserts.isTrue(a), "asserts.isFalse failure: expected "..tostr(a).." to not be true: "..tostr(failMsg)
end

function asserts.equals(a, b, failMsg)
    return a == b, "asserts.equals failure: "..tostr(a).." != "..tostr(b)..": "..tostr(failMsg)
end

function asserts.notEquals(a, b, failMsg)
    return not asserts.equals(a, b), "asserts.notEquals failure: "..tostr(a).." == "..tostr(b)..": "..tostr(failMsg)
end
