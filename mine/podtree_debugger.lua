-- From the pico8 discord "code-snippets"
-- To use, add "db_window()" to the end of your draw() function
-- [debug-window] --
_dblog,_dbopen = {},{}
_dbstate = "env"
_dby,_dbmy,_dbyy = 2,64,2
_dbscroll,_dbscrollto = 0,0

poke(0x5f2d,1)
function db_window()
    local top = 128-_dby
    local mp = stat(34)==1
    dbmp,dbmx,dbmy = not _dbmp and mp,stat(32),stat(33)
    _dbmp=mp
    
    -- window
 palt(0,false)
 pal(split"0,0,0,0,0,1,1,1,1,1,1,1,0,1,1")
 poke(0x5f54, 0x60)
 sspr(0,top,128,_dby+1,0,top)
 poke(0x5f54, 0x00) pal()
    line(0,top,128,top,7)
    
    -- hover
    local hover = dbmy>top
    local top_to = hover and _dbmy or _dbyy
    _dby = _dby+(top_to-_dby)*0.5
    
    if hover then
        _dbscrollto = _dbscrollto + stat(36)*5
        _dbscrollto = min(_dbscrollto,0)
    end
    
    -- contents
    local x,y = 1,top+2+_dbscroll
    clip(0,top+2,128,126-top)
    
    if _dbstate=="log" then
    
    elseif _dbstate=="env" then
        y = db_table(_𝘦𝘯𝘷,x,y)
    end
    clip()
    
    -- scroll
    _dbscroll = _dbscroll + (_dbscrollto-_dbscroll)*0.5
    
    -- cursor
    local cr="⁶:1f01050911000000"
    for xx=-1,1 do
    for yy=-1,1 do
        print(cr,xx+dbmx,yy+dbmy,0)
    end end
    print(cr,dbmx,dbmy,7)
    
end

function db_table(tbl,x,y)
    for k,v in pairs(tbl) do
        local t = type(v)
        local click = dbmp and dbmy>y and dbmy<y+7

        -- <tables> --
        if t=="table" then
            if click then _dbopen[k] = not _dbopen[k] end
            print((_dbopen[k] and "[-] [" or "[+] [")..k.."]",x,y,7)
            if _dbopen[k] then y = db_table(v,x+6,y+7)
            else y = y+7 end
            
        -- <ignore> --
        elseif t=="function" then
        
        -- <variables> --
        else
            if click and t=="boolean" then tbl[k]=not v end
            print("\fe"..k..": \fc"..tostr(v),x,y,7)
            y = y+7
            
        end
    end
    
    return y
end