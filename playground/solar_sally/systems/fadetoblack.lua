-- http://kometbomb.net/pico8/fadegen.html
-- 1. change settings on site (current settings: defaults except length 24)
-- 2. change bounds in fadetoblack.update() to match settings
-- 3. paste the table into compressor.p8 and the code here
-- 4. transform to lower case
-- 5. format code
-- 6. add '1' parameter to end of pal() calls so fading works on the title screen

function decompress_2d_number_table(s)
    local ret = {}
    for row in all(split(s,";")) do
        add(ret, split(row))
    end
    return ret
end

local fadetable = decompress_2d_number_table(fadetable_str) -- The table is stored in compressor.p8

function fade(i)
    for c = 0, 15 do
        if flr(i + 1) >= 24 then
            pal(c, 0, 1)
        else
            pal(c, fadetable[c + 1][flr(i + 1)], 1)
        end
    end
end
