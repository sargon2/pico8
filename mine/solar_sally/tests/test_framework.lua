framework_tests = {}

function framework_tests.assert_isTrue()
    assert.isTrue(true)
    assert.isTrue(asserts.isTrue(true))
    assert.isFalse(asserts.isTrue(false))
end

function framework_tests.assert_isFalse()
    assert.isFalse(false)
    assert.isTrue(asserts.isFalse(false))
    assert.isFalse(asserts.isFalse(true))
end

function framework_tests.assert_equals()
    assert.equals(true, true)
    assert.isTrue(asserts.equals(true, true))
    assert.isFalse(asserts.equals(true, false))
end

function framework_tests.assert_notEquals()
    assert.notEquals(true, false)
    assert.isTrue(asserts.notEquals(true, false))
    assert.isFalse(asserts.notEquals(true, true))
end

runTests("Framework tests", framework_tests)
