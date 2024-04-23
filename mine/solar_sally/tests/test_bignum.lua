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

function bignum_tests.test_basic_tostr()
    assert.equals("0", bignum_tostr({1, 0}))
    assert.equals("1", bignum_tostr({1, 1}))
    assert.equals("2", bignum_tostr({1, 2}))
    assert.equals("10001", bignum_tostr({2, 1, 1}))
    assert.equals("99999999", bignum_tostr({2, 9999, 9999}))
    assert.equals("19999", bignum_tostr({2, 1, 9999}))
    assert.equals("99990001", bignum_tostr({2, 9999, 1}))
    assert.equals("100010001", bignum_tostr({3, 1, 1, 1}))
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
    assert.dumpEquals({1, 1}, bignum_fromnum(1))
    assert.dumpEquals({1, 2}, bignum_fromnum(2))
    assert.dumpEquals({1, 0, 1000}, bignum_fromnum(.1))
    assert.dumpEquals({1, 0, 2000}, bignum_fromnum(.2))
    assert.dumpEquals({2, 2, 0}, bignum_fromnum(20000))
    assert.dumpEquals({1, 0, 1}, bignum_fromnum(.0001))
    assert.dumpEquals({2, 2, 3, 4}, bignum_fromnum(20003.0004))
end


-- TODO
-- Addition
-- Subtraction
-- Multiplication
-- Division

runTests("Bignum tests", bignum_tests)
