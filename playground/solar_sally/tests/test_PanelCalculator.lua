PanelCalculator_tests = {}


function PanelCalculator_tests.test_pico8_numbers()
    local f = 1 >> 16 -- smallest number pico-8 can handle
    assert.notEquals(f, 0)
    assert.equals("0.0000152587890625", full_tostr(f))

    -- Make sure it can be added properly
    local g = f + f
    assert.notEquals(f, g)
    assert.equals(g, f*2)

    local big = 0b111111111111111.1111111111111111 -- largest number pico-8 can handle
    assert.equals("32767.9999847412109375", full_tostr(big))
end

runTests("PanelCalculator tests", PanelCalculator_tests)