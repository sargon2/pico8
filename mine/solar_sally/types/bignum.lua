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

function bignum_tostr(num)
    local ret = ""
    local d = num[1]
    for i=2,#num do
        if(i == d+2) ret ..= "."
        n = tostr(num[i])
        if(i > 2) n = _pad_to_four(n)
        if(i == #num) n = _strip_trailing_zeroes(n)
        ret ..= n
    end
    return ret
end

function bignum_fromstr(numstr)
    local dec = str_find_char(numstr, '.')
    if(not dec) dec = #numstr+1

    local ip = sub(numstr, 0, dec-1)
    local fp = sub(numstr, dec+1, #numstr)
    ip = _strip_leading_zeroes(ip)
    if(ip == "") ip = "0"
    fp = _strip_trailing_zeroes(fp)

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
    return ret
end
