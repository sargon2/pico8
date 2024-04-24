function _pad_to_four(s)
    for i=#s,3 do
        s = "0"..s
    end
    return s
end

function _strip_trailing_zeroes(s)
    for i=#s,1,-1 do
        if s[i] != '0' then
            return sub(s, 0, i)
        end
    end
    return ""
end

function _strip_leading_zeroes(s)
    for i=1,#s do
        if s[i] != '0' then
            return sub(s, i)
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
    local ret = ""
    local d = num[1]
    for i=2,#num do
        if(i == d+2) ret ..= "."
        if i==2 then
            n = tostr(num[2]) -- for negative sign
        else
            n = tostr(abs(num[i]))
        end
        if(i > 2) n = _pad_to_four(n)
        if(i == #num and i>d+1) n = _strip_trailing_zeroes(n) -- We can't use _trim_bignum because it doesn't trim within a component
        ret ..= n
    end
    if(ret == "") ret = "0"
    return ret
end

function bignum_fromstr(numstr) -- TODO can this be removed for the final cart? It may be only used for testing. I could move it to the test file.
    local dec = str_find_char(numstr, '.')
    if(not dec) dec = #numstr+1

    local ip = sub(numstr, 0, dec-1)
    local fp = sub(numstr, dec+1, #numstr)

    local ret = {}
    
    for i=#ip-3,-3,-4 do
        local s = sub(ip, max(i,1), i+3)
        add(ret, tonum(s))
    end

    reverse_table(ret)

    local ip_size = #ret

    local fp_size = #fp
    fp = fp .. "000" -- Needed so last group has correct order of magnitude
    for i=1,fp_size,4 do
        local s = sub(fp, i, i+3)
        add(ret, tonum(s))
    end
    add(ret, ip_size, 1)
    _trim_bignum(ret)
    return ret
end

function bignum_fromnum(n)
    -- example: 20003.0004
    local ip = flr(n) -- 20003

    local tenthousands = flr(ip/10000) -- 2

    -- There is some accuracy past here, but we start to get into weird rounding errors.
    -- So, we just truncate numbers to 4 digits past the decimal, same as print().

    ret = {}
    if tenthousands == 0 then
        add(ret, 1)
    else
        add(ret, 2)
        add(ret, tenthousands)
    end

    add(ret, ip-(tenthousands*10000)) -- 3

    local tenthousandths = flr(((n-ip)*10000)+0.5) -- 4
    if(tenthousandths != 0) add(ret, tenthousandths)
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

function bignum_add(num1, num2)
    -- Avoid modifying args
    num1, num2 = bignum_copy(num1), bignum_copy(num2)
    -- zero-pad beginning of smaller number to align decimals
    pad_beginning(num1, num2[1])
    pad_beginning(num2, num1[1])
    -- zero-pad end of shorter number to align sizes
    pad_end(num1, #num2)
    pad_end(num2, #num1)
    local ret_size = num1[1]

    local ret = {}
    local carry = 0
    for i=#num1,2,-1 do
        local res = num1[i] + num2[i] + carry
        carry = 0
        if res >= 10000 then
            carry += 1
            res -= 10000
        elseif res <= -10000 then
            carry -= 1
            res += 10000
        end
        add(ret, res)
    end
    if carry != 0 then
        add(ret, carry)
        ret_size += 1
    end
    reverse_table(ret)

    add(ret, ret_size, 1)

    _trim_bignum(ret)
    return ret
end