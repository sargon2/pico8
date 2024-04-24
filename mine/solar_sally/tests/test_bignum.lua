bignum_tests = {}

function bignum_tests.test_strip_trailing_zeroes()
    assert.equals("", _strip_trailing_zeroes("0"))
    assert.equals("1", _strip_trailing_zeroes("10"))
    assert.equals("1", _strip_trailing_zeroes("10000000000"))
    assert.equals("0101", _strip_trailing_zeroes("01010000000000"))
end

function bignum_tests.test_strip_leading_zeroes()
    assert.equals("", _strip_leading_zeroes("0"))
    assert.equals("1", _strip_leading_zeroes("01"))
    assert.equals("1", _strip_leading_zeroes("000000000001"))
    assert.equals("1010", _strip_leading_zeroes("000000000001010"))
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
end

function bignum_tests.test_decimals()
    assert.equals("1.1", bignum_tostr({1, 1, 1000}))
    assert.equals("11", bignum_tostr({1, 11}))
    assert.equals("0.11", bignum_tostr({1, 0, 1100}))
end

function bignum_tests.test_fromstr()
    -- Test basic numbers without a decimal point
    assert.dumpEquals({1, 0}, bignum_fromstr("0"))
    assert.dumpEquals({1, 1}, bignum_fromstr("1"))
    assert.dumpEquals({1, 1000}, bignum_fromstr("1000"))
    assert.dumpEquals({1, 0}, bignum_fromstr("0"))

    -- Test numbers with trailing zeroes
    assert.dumpEquals({1, 1000}, bignum_fromstr("1000"))
    assert.dumpEquals({2, 1, 0}, bignum_fromstr("10000"))
    assert.dumpEquals({3, 1, 0, 0}, bignum_fromstr("100000000"))
    assert.dumpEquals({1, 0, 1000}, bignum_fromstr("0.1000000000000000000000"))

    -- Test numbers with a decimal point
    assert.dumpEquals({1, 1, 1000}, bignum_fromstr("1.1"))
    assert.dumpEquals({1, 100, 1234}, bignum_fromstr("100.1234"))
    assert.dumpEquals({2, 9999, 9999, 1}, bignum_fromstr("99999999.0001"))

    -- Handling leading zeros
    assert.dumpEquals({1, 1}, bignum_fromstr("00001"))
    assert.dumpEquals({1, 1, 2000}, bignum_fromstr("01.2"))
    
    -- Complex numbers with zeros between significant digits
    assert.dumpEquals({3, 100, 0, 1}, bignum_fromstr("10000000001"))
    assert.dumpEquals({1, 0, 1}, bignum_fromstr("0.0001"))

    -- Edge case: Very large/small number
    assert.dumpEquals({5, 1, 0, 0, 0, 1}, bignum_fromstr("10000000000000001"))
    assert.dumpEquals({1, 0, 0, 0, 1}, bignum_fromstr("0.000000000001"))
end

function bignum_tests.test_fromnum()
    assert.dumpEquals({1, 0}, bignum_fromnum(0))
    assert.dumpEquals({1, -1}, bignum_fromnum(-1))
    assert.dumpEquals({1, 1}, bignum_fromnum(1))
    assert.dumpEquals({1, 2}, bignum_fromnum(2))
    assert.dumpEquals({1, 0, 1000}, bignum_fromnum(.1))
    assert.dumpEquals({1, 0, 2000}, bignum_fromnum(.2))
    assert.dumpEquals({2, 2, 0}, bignum_fromnum(20000))
    assert.dumpEquals({1, 0, 1}, bignum_fromnum(.0001))
    assert.dumpEquals({2, 2, 3, 4}, bignum_fromnum(20003.0004))
    assert.dumpEquals({2, -1, -2679}, bignum_fromnum(-12679)) -- this one actually failed
end

function verify_add(expected, num1, num2)
    assert.dumpEquals(expected, bignum_add(num1, num2))
    assert.dumpEquals(expected, bignum_add(num2, num1))
end

function bignum_tests.test_add_copies_args()
    -- Make sure add doesn't modify its args
    local num1 = {1, 4}
    local num2 = {3, 1,  2, 3}
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

-- TODO
-- Multiplication
-- Division

runTests("Bignum tests", bignum_tests)
