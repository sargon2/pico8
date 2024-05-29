-- Things that should be built into Lua but aren't.

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostr(o)
    end
end

-- Turn the given function (coroutine) into an iterator.  It should call 'yield' to return each value.
function make_iter(f, ...)
    local cor = cocreate(f)
    local args = {...}
    return function ()
        if cor and costatus(cor) != 'dead' then
            local _, val = coresume(cor, unpack(args))
            return val
        else
            return nil
        end
    end
end

-- Be careful using this, it's O(n)
function contains(haystack, needle)
    for val in all(haystack) do
        if val == needle then
            return true
        end
    end
    return false
end

-- Sort the given array.
-- Takes a comparison function as an argument to determine the sorting order.
-- compare(a, b) should return true or false.
-- Requires the array passed in to be index-based.
function quicksort(arr, compare)
    _quicksort(arr, 1, #arr, compare)
end

function _quicksort(arr, low, high, compare)
    if low < high then
        local pi = _partition(arr, low, high, compare)

        _quicksort(arr, low, pi - 1, compare)
        _quicksort(arr, pi + 1, high, compare)
    end
end

function _partition(arr, low, high, compare)
    local pivot = arr[high]
    local i = low - 1

    for j = low, high - 1 do
        if compare(arr[j], pivot) then
            i = i + 1
            swap(arr, i, j)
        end
    end
    swap(arr, i + 1, high)
    return i + 1
end

function swap(arr, i, j)
    arr[i], arr[j] = arr[j], arr[i]
end

-- This allows us to deduplicate constructor functions for simulated objects.
function NewObj(type, ...)
    local o = {}
    setmetatable(o, type)
    type.__index = type

    if(o.construct) o:construct(...)

    return o
end

function printh_all(...)
    local ret = ""
    for i in all({...}) do
        ret ..= dump(i) .. ", "
    end
    printh(ret)
end

function str_find_char(haystack, needle)
    -- Only works for finding single characters
    for i=1,#haystack do
        if(haystack[i] == needle) return i
    end
    return nil
end

function reverse_table(t)
    for i=1,#t/2 do
        t[i], t[#t-i+1] = t[#t-i+1], t[i]
    end
end

-- Converts the given number to a string without truncating or rounding.
function full_tostr(n)
    local ret = ""
    if n < 0 then
        ret ..= "-"
        n = -n
        if(n < 0) ret = "" -- Overflow
    end
    ret ..= tostr(flr(n))
    n -= flr(n)
    if n != 0 then
        ret ..= "."
        repeat
            n *= 10
            ret ..= flr(n)
            n -= flr(n)
        until n <= 0
    end
    return ret
end

-- table[arg1][arg2][arg3][...] = argn
-- requires at least 2 args after the table for table[arg1] = arg2
function set_with_ensure(table, ...)
    local args = {...}
    local last_element = deli(args, #args)
    for i, e in pairs(args) do
        if i == #args then
            table[e] = last_element
            return
        end
        if(not table[e]) table[e] = {}
        table = table[e]
    end
end

function get_var_name(sys) -- O(n) in number of variables
    for k, v in pairs(_ENV) do
        if v == sys then
            return k
        end
    end
end

function limit_to(val, min, max)
    if val < min then
        return -1, min
    elseif val > max then
        return 1, max
    end
    return 0, val
end

function noop() end
