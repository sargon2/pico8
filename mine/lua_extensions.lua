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
function NewObj(type)
    local o = {}
    setmetatable(o, type)
    type.__index = type

    if(o.construct) o:construct()

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

