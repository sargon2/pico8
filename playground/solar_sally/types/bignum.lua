-- A bignum is a table.  The first element of the table is the position of the decimal point.
-- The remaining elements are base-10000 components of the number.
-- So, for example, {2, 1, 3, 4000} is 10003.4.
-- Negative numbers are stored such that all components are negative, so e.g. -10001 is {2, -1, -1}.

--[[const]] baselen = 4 -- 4=10000
--[[const]] base = 10^baselen

function _strip_trailing_zeroes(s)
    for i=#s,1,-1 do
        if s[i] ~= '0' then
            return sub(s, 0, i)
        end
    end
    return ""
end

function _trim_bignum(num) -- modifies its arg
    local dec=num[1]

    -- Trim LHS
    while dec > 1 and num[2] == 0 do
        dec -= 1
        deli(num, 2)
    end
    num[1] = dec

    -- Trim RHS
    while #num > dec+1 and num[#num] == 0 do
        deli(num, #num)
    end
end

function bignum_tostr(num)
    local function _pad_to_base(s)
        for i=#s,baselen-1 do
            s = "0"..s
        end
        return s
    end

    local ret = ""
    local d = num[1]
    for i=2,#num do
        if(i == d+2) ret ..= "."
        if i==2 then
            n = tostr(num[2]) -- for negative sign
        else
            n = tostr(abs(num[i]))
        end
        if(i > 2) n = _pad_to_base(n)
        if(i == #num and i>d+1) n = _strip_trailing_zeroes(n) -- We can't use _trim_bignum because it doesn't trim within a component
        ret ..= n
    end
    if(ret == "") ret = "0"
    return ret
end

function bignum_flip_sign(num)
    for i=2,#num do
        num[i] = -num[i]
    end
end

function bignum_fromnum(n)
    local is_negative = false
    if n < 0 then
        is_negative = true
        n = -n
    end

    local ret = {1}
    repeat
        ret[#ret+1] = flr(n)
        n -= flr(n)
        n *= base
    until n==0

    _perform_carry(ret, n<0)
    _trim_bignum(ret)
    if(is_negative) bignum_flip_sign(ret)
    return ret
end

function bignum_copy(num)
    ret = {}
    for i in all(num) do
        add(ret, i)
    end
    return ret
end

function pad_beginning(num, size) -- modifies its arg
    while num[1] < size do
        add(num, 0, 2)
        num[1] += 1
    end
end

function pad_end(num, size) -- modifies its arg
    while #num < size do
        add(num, 0)
    end
end

function copy_and_align_sizes(num1, num2)
    num1, num2 = bignum_copy(num1), bignum_copy(num2)
    -- zero-pad beginning of smaller number to align decimals
    pad_beginning(num1, num2[1])
    pad_beginning(num2, num1[1])
    -- zero-pad end of shorter number to align sizes
    pad_end(num1, #num2)
    pad_end(num2, #num1)
    return num1, num2
end

function _perform_carry(num, is_negative) -- modifies arg
    local min, max = 0, base-1
    if(is_negative) min, max = -base+1, 0
    local carry = 0
    for i=#num,2,-1 do
        local res = num[i] + carry
        carry = 0

        while res > max do
            carry += 1
            res -= base
        end
        while res < min do
            carry -= 1
            res += base
        end

        num[i] = res
    end
    local ret_size = num[1]
    if carry ~= 0 then
        ret_size += 1
        add(num, carry, 2)
    end
    num[1] = ret_size
end

function bignum_add(num1, num2)
    -- Avoid modifying args
    num1, num2 = copy_and_align_sizes(num1, num2)

    -- We have to do this in two passes because the carry ranges depend on
    -- the sign of the result, and we don't know the sign of the result
    -- until we've added the most significant two numbers that add to non-zero.

    ret={0}
    local is_negative
    for i=2,#num1 do
        local c = num1[i] + num2[i]
        ret[i] = c
        if is_negative == nil then
            if(c > 0) is_negative = false
            if(c < 0) is_negative = true
        end
    end
    if(is_negative == nil) return {1, 0}

    ret[1] = num1[1]
    _perform_carry(ret, is_negative)

    _trim_bignum(ret)
    return ret
end

function bignum_mult(num1, num2)
    return {1, 6}
end
