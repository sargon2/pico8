bignum_tests = {}

function bignum_tests.test_strip_trailing_zeroes()
    assert.equals("", _strip_trailing_zeroes("0"))
    assert.equals("1", _strip_trailing_zeroes("10"))
    assert.equals("1", _strip_trailing_zeroes("10000000000"))
    assert.equals("0101", _strip_trailing_zeroes("01010000000000"))
end

function bignum_tests.test_tostr()
    assert.equals("0", bignum_tostr({1, 0}))
    assert.equals("1", bignum_tostr({1, 1}))
    assert.equals("2", bignum_tostr({1, 2}))
    assert.equals("5000", bignum_tostr({1, 5000}))
    assert.equals("50000000", bignum_tostr({2, 5000, 0}))
    assert.equals("10001", bignum_tostr({2, 1, 1}))
    assert.equals("99999999", bignum_tostr({2, 9999, 9999}))
    assert.equals("19999", bignum_tostr({2, 1, 9999}))
    assert.equals("99990001", bignum_tostr({2, 9999, 1}))
    assert.equals("100010001", bignum_tostr({3, 1, 1, 1}))

    -- ensure _pad_to_four works
    assert.equals("10000", bignum_tostr({2, 1, 0}))
    assert.equals("10010", bignum_tostr({2, 1, 10}))
    assert.equals("10100", bignum_tostr({2, 1, 100}))
    assert.equals("11000", bignum_tostr({2, 1, 1000}))

    -- negative
    assert.equals("-1", bignum_tostr({1, -1}))
    assert.equals("-10002", bignum_tostr({2, -1, -2}))
    assert.equals("-1.2", bignum_tostr({1, -1, -2000}))

    assert.equals("0.1", bignum_tostr({1, 0, 1000}))
    assert.equals("1.1", bignum_tostr({1, 1, 1000}))
    assert.equals("11", bignum_tostr({1, 11}))
    assert.equals("0.11", bignum_tostr({1, 0, 1100}))
    assert.equals("0.000000000001", bignum_tostr({1, 0, 0, 0, 1}))
end

function assert_bignumStr(expected, actual)
    assert.equals(expected, bignum_tostr(actual))
end

function bignum_tests.test_fromnum()
    assert_bignumStr("0", bignum_fromnum(0))
    assert_bignumStr("-1", bignum_fromnum(-1))
    assert_bignumStr("1", bignum_fromnum(1))
    assert_bignumStr("2", bignum_fromnum(2))
    assert_bignumStr("0.0999908447265625", bignum_fromnum(.1))
    assert_bignumStr("0.1999969482421875", bignum_fromnum(.2))
    assert_bignumStr("0.25", bignum_fromnum(.25))
    assert_bignumStr("0.125", bignum_fromnum(.125))
    assert_bignumStr("20000", bignum_fromnum(20000))
    assert_bignumStr("0.000091552734375", bignum_fromnum(.0001))
    assert_bignumStr("20003.000396728515625", bignum_fromnum(20003.0004))
    assert_bignumStr("-12679", bignum_fromnum(-12679)) -- this one actually failed

    assert_bignumStr("0.0002899169921875", bignum_fromnum(0.0003))
    assert_bignumStr("0.0000152587890625", bignum_fromnum(0.00003))
    assert_bignumStr("0", bignum_fromnum(0.000003))
end

function verify_add(expected, num1, num2)
    assert.dumpEquals(expected, bignum_add(num1, num2))
    assert.dumpEquals(expected, bignum_add(num2, num1))
end

function bignum_tests.test_add_copies_args()
    -- Make sure add doesn't modify its args
    local num1 = {1, 4}
    local num2 = {3, 1, 2, 3}
    bignum_add(num1, num2)
    assert.dumpEquals({1, 4}, num1)
end

function bignum_tests.test_add()
    verify_add({1, 0}, {1, 0}, {1, 0})
    verify_add({1, 3}, {1, 1}, {1, 2})
    verify_add({1, 5}, {1, 2}, {1, 3})
    verify_add({2, 4, 6}, {2, 1, 2}, {2, 3, 4})
    verify_add({2, 1, 5}, {2, 1, 2}, {1, 3})
    verify_add({3, 1, 2, 7}, {3, 1, 2, 3}, {1, 4})
    verify_add({3, 1, 6, 8}, {3, 1, 2, 3}, {2, 4, 5})
    verify_add({2, 1, 0}, {1, 5000}, {1, 5000}) -- overflows; can't trim right side
    verify_add({4, 1, 0, 0, 0}, {3, 4000, 0, 0}, {3, 6000, 0, 0}) -- can't trim right side (more)
    verify_add({2, 1, 0}, {1, 4000}, {1, 6000}) -- overflows, but numbers are different
    verify_add({1, 0, 3}, {1, 0, 1}, {1, 0, 2})
    verify_add({1, 0, 2, 1}, {1, 0, 0, 1}, {1, 0, 2})
    verify_add({1, 0, 7, 3, 4}, {1, 0, 2, 3, 4}, {1, 0, 5})
    verify_add({3, 1, 3, 5, 7, 5}, {3, 1, 2, 3, 4, 5}, {2, 1, 2, 3})
    verify_add({1, 1}, {1, 0, 4000}, {1, 0, 6000}) -- must trim right side

    -- negative
    verify_add({1, -3}, {1, -1}, {1, -2})
    verify_add({2, -4, -6}, {2, -1, -2}, {2, -3, -4})
    verify_add({1, 0}, {1, 1}, {1, -1})
    verify_add({1, 0}, {2, -1, 0}, {2, 1, 0}) -- must trim LHS
    verify_add({2, -1, -5}, {2, -1, -2}, {1, -3})

    verify_add({1, 1}, {2, -1, 0}, {2, 1, 1}) -- trim LHS; result is positive
    verify_add({1, -1}, {2, 1, 0}, {2, -1, -1}) -- trim LHS; result is negative

    verify_add({2, 2, 2}, {2, -1, -2}, {2, 3, 4})
    verify_add({2, -2, -2}, {2, 1, 2}, {2, -3, -4})

    verify_add({2, -1, 0}, {1, -4000}, {1, -6000}) -- Underflows

    verify_add({2, 1, 0}, {1, 9999}, {1, 1})
    verify_add({2, -1, 0}, {1, -9999}, {1, -1})
    verify_add({1, 9999}, {2, 1, 0}, {1, -1}) -- Mixes positive and negative components
    verify_add({1, -9999}, {2, -1, 0}, {1, 1}) -- Mixes positive and negative, the other way

    -- Mix more
    verify_add({4, 1, 0, 0, 0}, {3, 9999, 9999, 9999}, {1, 1})
    verify_add({4, -1, 0, 0, 0}, {3, -9999, -9999, -9999}, {1, -1})
    verify_add({3, 9999, 9999, 9999}, {4, 1, 0, 0, 0}, {1, -1})
    verify_add({3, -9999, -9999, -9999}, {4, -1, 0, 0, 0}, {1, 1})

    -- Carry causes a sign change in the result
    verify_add({1, -2}, {2, -1, -1}, {1, 9999})
    verify_add({1, 2}, {2, 1, 1}, {1, -9999})
end

function verify__trim_bignum(expected, num)
    _trim_bignum(num)
    assert.dumpEquals(expected, num)
end

function bignum_tests.test__trim_bignum()
    verify__trim_bignum({1, 2, 3}, {1, 2, 3})
    verify__trim_bignum({1, 2, 3}, {4, 0, 0, 0, 2, 3, 0, 0, 0, 0})
    verify__trim_bignum({1, 0, 1}, {1, 0, 1})
    verify__trim_bignum({2, 1, 0}, {2, 1, 0})
end

function bignum_tests.test_bignum_mult()
    assert.dumpEquals({1, 6}, bignum_mult({1, 2}, {1, 3}))
end

-- TODO
-- Multiplication
-- Division

runTests("Bignum tests", bignum_tests)
