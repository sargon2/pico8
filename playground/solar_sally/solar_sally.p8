pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../lua_extensions.lua
#include ../vector_utils.lua
#include ../podtree_debugger.lua
#include ../easing.lua

#include types/BooleanGrid.lua
#include types/twonum.lua

#include components/Settings.lua
#include components/Entities.lua
#include components/Sprites.lua
#include components/SFX.lua
#include components/Locations.lua
#include components/SmoothLocations.lua
#include components/Attributes.lua
#include components/Actions.lua

#include systems/Input.lua
#include systems/PerfTimer.lua
#include systems/FrameTimer.lua
#include systems/CoroutineRunner.lua
#include systems/Placement.lua
#include systems/World.lua
#include systems/PanelCalculator.lua
#include systems/Circuits.lua
#include systems/Inventory.lua
#include systems/fadetoblack.lua
#include systems/IndoorWorld.lua
#include systems/Axe.lua

#include entities/Character.lua
#include entities/Panels.lua
#include entities/Rocks.lua
#include entities/Trees.lua
#include entities/Cows.lua
#include entities/Wire.lua
#include entities/Transformers.lua
#include entities/GridWire.lua
#include entities/Button.lua
#include entities/Fence.lua

#include solar_sally.lua
__gfx__
00000000000000000044440000000000004440000000000000444400000000000044400000000000004444000000f00000000000222222222222222222222222
000000000044440000444f000044400004444400004444000044f40000444000044f440000444400044444000004444404444000222222222222222222222222
0070070000444f00044f1f0004444400044444000044f4000441f100044f4400041f14000444440004444f0060f4444f0444f000222227777777777777722222
00077000044f1f00044fff0004444400044444000441f100044fff00041f140004fff40004444f0004444f00664e4f1f44f1f000222277666666666666772222
00077000044fff0000eee0000444440000444000044fff0000eee00004fff40004eee40004444f000044e0004604efff44fff000222776666666666666677222
0070070000eee00000dfd0000044400000d4d00000eee00000fddf0004eee4000fdddf000044e000004ddf000000eee00ef44f66225766666666666666667222
0000000000fdd0000d000d0000d4d00000d0d00000fddf000d000d000fdddf0000d0d000004ddf000d000d000000ddd00ddd0066225766666666666666667222
0000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d000000000000000d0d0d00d0000225766666666666666667222
33333333000700002222222222222222222222227770007722222222222222220000000000000000222022222222222200000000257766666666666666667722
33b33333007c700022666222222666222222222270033b0707000007700070070000000000000000220a02222222202200000000575766666666666666667572
533333b307ccc700222022666622022222222222033333b00777117007770170008888000066660020a9a0222222040200000000575766666666666666667572
333533337cc7cc70220066200266002222266222053333b000771170007001706888888666888866220a02222220460200000400575766666666666666667572
3333b33307cc1cc7220666666666602226200262053333b007777710077707106888888668888886220a02222204666000004600575766666666666666667572
33333333017ccc702206616666cc60222066c602003333300e07777020e077706588885668888886220a90222040060200046660575766666666666666667572
b33333330107c7002208888888888022208888020333330020070e7022070e706655556666888866220a02220402202200400600575766666666666666667572
33533b330000700022000000000000222000000205333bb022202202222022020066660000666600222022222022222204000000257766666666666666667722
aa0000aa00000000000000000000000022222222053333b077000777000000002222222200000000000000000000000000000000225766666666666666667222
a000000a00000000000000000000000022222222053333307033b077000000002000222200000000000000000000000000000000225766666666666666667222
00000000000000000000000000000000222222227053300703333b07000000000fff022200000000000000000000000000000000225776666666666666677222
00000000000000000000000000000000222222227700007705333307000000000ffff02200000000000000000000000000000000225577666666666666772222
00000000007000000008000000000000222222227704907770343077000000000fff0f0200000000000000000000000000000000222557777777777777722222
0000000007c70000008880000080800028888822702449077704077700000000200f002200000000000000000404040000000000222255555555555555222222
a000000a017c7000080808000008000020000022770200777704077700000000220f022200000000000000000444440000000000222222222222222222222222
aa0000aa010700000008000000808000222222227770777777707777000000002220222200000000000000000454540000000000222222222222222222222222
00000000222222222222222222208222222222220000000022222222000000000000000000000000000050000000000000000000000000000000000000000000
00000000222222222222222222208222222222220000000022222222000000000000000000000000000040000000000000000000000000000000000000000000
006666002222222222222222222082222222222200000000222222223bbaabb30000000000000000000050000000000000000000000000000000000000000000
065655608888822222228888222082222222822200000000aaaaaaaabb3aa3bb4040400000004040000040000000400000000000000000000000000000000000
05566660000022222220000022202222222082220000000000000000bb3aa3bb4444400000004444000040000000500000000000000000000000000000000000
115566502222222222222222222222222220822200000000222222223bbaabb34545400000004545000040000000400000000000000000000000000000000000
11155500222222222222222222222222222082220000000022222222000000000000000000000000000000000000500000000000000000000000000000000000
00000000222222222222222222222222222082220000000022222222000000000000000000000000000000000000400000000000000000000000000000000000
00000000000000000000000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000044544444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000044444445444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555000044444444444444540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005777777775777775000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005777777775777775000044444444445444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775555500005775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775666500005775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775666500005775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555666500005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775555500005775000055555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775666500005775000077777577777775770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775666500005775000077777577777775770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775666500005775000077777577777775770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775000055555775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775000056665775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775000056665775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555000056665555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005775000055555775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005777000056667775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005777000056667775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005777000056667775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666666665666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666666665666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666666665666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666656666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666656666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005666656666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000040401010100000101010201010000010100010101000000000102020001000000000101010001010101000100000000000000000000000000000000000000000000000000081808181800000000000000000000000018000000000000000000000000000008080800000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101010000000004041414141414142000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000005071717171717152000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000005071717171717152000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000005043444344434452000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000005043444344434452000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000006053545354535462000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000007071717171717172000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000007071514361717172000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0101000005610136200d6100060000600096001e6001e6001e6001e6001e6001d6001d6001d6001d6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c6001c600
010100001b3501c3501c35000000000000000000300003000030000300003002b3502b3502b3502d3500030000300003000030000300003000030000300003000030000300003000030000300003000030000000
010100002b3502b3502b3502a35000000000000000000000000000000000000003001c3501c3501c3500030000300003000030000300003000030000300003000030000300003000000000000000000000000000
010100002b3502b3502d3500030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000000
9001000024020210101b0101901018010190101a0101d01020010250202903016000140001200011000100000f0000e000180000e0000f00010000100001100014000150001a0001e00020000250000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002000001885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__meta:title__
Solar Sally
