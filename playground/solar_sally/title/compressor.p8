pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

local fadetable = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 1, 1, 1, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 0, 0, 0, 0, 0, 0, 0 },
    { 2, 2, 2, 2, 2, 130, 130, 130, 130, 130, 130, 130, 130, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0 },
    { 3, 3, 3, 3, 3, 131, 131, 131, 131, 131, 129, 129, 129, 129, 129, 129, 129, 129, 0, 0, 0, 0, 0 },
    { 4, 4, 4, 4, 132, 132, 132, 132, 132, 132, 132, 132, 130, 130, 128, 128, 128, 128, 128, 128, 0, 0, 0 },
    { 5, 5, 5, 133, 133, 133, 133, 133, 133, 133, 130, 130, 128, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0 },
    { 6, 6, 6, 134, 134, 13, 13, 13, 13, 13, 5, 5, 5, 5, 5, 133, 133, 130, 128, 128, 128, 128, 0 },
    { 7, 7, 6, 6, 6, 6, 6, 134, 134, 134, 134, 134, 141, 5, 5, 5, 133, 133, 130, 128, 128, 128, 0 },
    { 8, 8, 8, 136, 136, 136, 136, 136, 136, 136, 132, 132, 132, 132, 130, 130, 128, 128, 128, 128, 128, 0, 0 },
    { 9, 9, 9, 9, 9, 4, 4, 4, 4, 4, 132, 132, 132, 132, 132, 132, 128, 128, 128, 128, 128, 0, 0 },
    { 10, 10, 10, 138, 138, 138, 138, 138, 4, 4, 4, 4, 132, 132, 132, 132, 133, 128, 128, 128, 128, 128, 0 },
    { 11, 11, 139, 139, 139, 139, 139, 139, 3, 3, 3, 3, 3, 131, 129, 129, 129, 129, 128, 0, 0, 0, 0 },
    { 12, 12, 12, 12, 140, 140, 140, 140, 140, 140, 140, 131, 131, 131, 131, 1, 1, 129, 129, 129, 129, 0, 0 },
    { 13, 13, 13, 13, 141, 141, 141, 5, 5, 5, 133, 133, 133, 133, 130, 130, 129, 129, 128, 128, 128, 0, 0 },
    { 14, 14, 14, 14, 134, 134, 134, 141, 141, 141, 141, 2, 2, 2, 133, 133, 130, 130, 128, 128, 128, 128, 0 },
    { 15, 15, 143, 143, 134, 134, 134, 134, 134, 134, 134, 5, 5, 5, 5, 133, 133, 133, 130, 128, 128, 128, 0 }
}

function compress_2d_number_table(t)
    local ret = ""
    for row in all(t) do
        for num in all(row) do
            ret ..= num..","
        end
        ret = sub(ret, 1, #ret-1)..";"
    end
    return sub(ret, 1, #ret-1)
end

function _init()
	printh("-- importing title.png")
	import "title.png"

	printh("-- Calling encode_string()")
	new_s=""
	encode_string()

	printh("-- len of title string is "..tostr(#new_s))

	printh("--[[const]] title_image=\""..new_s.."\"")

	printh("-- Saving label image screenshot")
	memcpy(0x6000, 0, 0x2000)
	extcmd("screen")

	printh("-- Outputting compressed fade table")
	local fade_s = compress_2d_number_table(fadetable)
	printh("-- len of fadetable is "..#fade_s)
	printh("--[[const]] fadetable_str = \""..fade_s.."\"")

	printh("-- done")
end

-- https://www.lexaloffle.com/bbs/?tid=38829

--string encoder
--encodes spritesheet image to
--compressed string

--draw,paste or import image to
--spritesheet. if image is not
--full-screen size, position
--in top left corner and enter
--image width and height
--in pixels. then run cart,press
--⬇️ to enter 'encode string'
--mode, and press ❎ to encode
--image string and paste it to
--the clipboard.

function encode_string()

	w=128
	h=128
	
	t={}
	i,x,y=1,0,0
	len=1
   
	while y<h do
	 local curcol,nxtcol=sget(x,y),sget(x+1,y)
	 if nxtcol==curcol and x<w-1
	  then len+=1
	  else
	   t[i]=curcol
	   t[i+1]=len
	   len=1
	   i+=2
	 end
	 x+=1
	 if(x==w)x=0 y+=1
	end
   
	new_s=new_s..'`'..chr(w-1+96)..'`'..chr(h-1+96)
	for i=1,#t do
	 new_s..=chr(t[i]+96)
	end printh(new_s,'@clip')
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
