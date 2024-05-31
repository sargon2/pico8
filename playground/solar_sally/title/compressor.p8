pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	printh("importing title.png")
	import "title.png"

	printh("Calling encode_string()")
	new_s=""
	encode_string()

	printh("len is "..tostr(#new_s))

	printh("title_image=\""..new_s.."\"")

	printh("Saving label image screenshot")
	memcpy(0x6000, 0, 0x2000)
	extcmd("screen")

	printh("done")
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
