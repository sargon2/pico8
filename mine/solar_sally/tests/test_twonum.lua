twonum_tests = {}

function twonum_tests.test_basic_tostr()
    assert.equals("0", NewObj(twonum, 0):tostr())
    assert.equals("0", NewObj(twonum, -0):tostr())
    assert.equals("1", NewObj(twonum, 1):tostr())
    assert.equals("0.25", NewObj(twonum, 0.25):tostr())
    assert.equals("32767", NewObj(twonum, 32767):tostr())
    assert.equals("32767.9999847412109375", NewObj(twonum, 0b111111111111111.1111111111111111):tostr())
end

function twonum_tests.test_no_shared_state()
    local num1 = NewObj(twonum, 1)
    local num2 = NewObj(twonum, 2)

    assert.equals("1", num1:tostr())
    assert.equals("2", num2:tostr())
end

function twonum_tests.test_add()
    local num = NewObj(twonum, 0)
    num:add(1)
    assert.equals("1", num:tostr())
end

function _verify_add(a, b, expected)
    local num = NewObj(twonum, a)
    num:add(b)
    assert.equals(expected, num:tostr())
end

function twonum_tests.test_adds()
    _verify_add(32000, 10000, "42000")
    _verify_add(10000, 32000, "42000")
    _verify_add(0b111111111111111.1111111111111111, 0b111111111111111.1111111111111111, "65535.999969482421875")
    _verify_add(10, -1, "9")
end

function twonum_tests.test_big_subtract()
    local num = NewObj(twonum, 20000)
    num:add(20000) -- now 40000
    num:add(-32768) -- largest possible subtraction we support
    assert.equals("7232", num:tostr())
end

function twonum_tests.test_really_big()
    local num = NewObj(twonum, 0.9999847412109375)
    for i=1,10000 do
        num:add(32767)
    end
    num:add(9999)
    assert.equals("327679999.9999847412109375", num:tostr())
end

runTests("twonum tests", twonum_tests)
