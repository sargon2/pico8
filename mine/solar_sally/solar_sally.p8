pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../floating_point.lua
#include ../lua_extensions.lua
#include ../vector_utils.lua
#include ../podtree_debugger.lua
#include types/BooleanGrid.lua
#include indexes/Settings.lua
#include components/Sprites.lua
#include components/Entities.lua
#include components/Locations.lua
#include components/SmoothLocations.lua
#include components/Attributes.lua
#include systems/PerfTimer.lua
#include systems/FrameTimer.lua
#include systems/Placement.lua
#include systems/World.lua
#include systems/Map.lua
#include systems/PanelCalculator.lua
#include systems/Circuits.lua
#include systems/Inventory.lua
#include entities/Character.lua
#include entities/Panels.lua
#include entities/Rocks.lua
#include entities/Trees.lua
#include entities/Cows.lua
#include entities/Wire.lua
#include entities/Transformers.lua
#include entities/GridWire.lua
#include entities/Button.lua
#include solar_sally.lua
__gfx__
00000000000000000044440000000000004440000000000000444400000000000044400000000000004444000000000000000000222222222222222222222222
000000000044440000444f000044400004444400004444000044f40000444000044f440000444400044444000000000000000000222222222222222222222222
0070070000444f00044f1f0004444400044444000044f4000441f100044f4400041f14000444440004444f000000000000000000222227777777777777722222
00077000044f1f00044fff0004444400044444000441f100044fff00041f140004fff40004444f0004444f000000000000000000222277666666666666772222
00077000044fff0000eee0000444440000444000044fff0000eee00004fff40004eee40004444f000044e0000000000000000000222776666666666666677222
0070070000eee00000dfd0000044400000d4d00000eee00000fddf0004eee4000fdddf000044e000004ddf000000000000000000225766666666666666667222
0000000000fdd0000d000d0000d4d00000d0d00000fddf000d000d000fdddf0000d0d000004ddf000d000d000000000000000000225766666666666666667222
0000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d000000000000000000000000000225766666666666666667222
33333333000700002222222222222222222222227770007722222222222222220000000000000000000000000000000000000000257766666666666666667722
33b33333007c700022666222222666222222222270033b0707000007700070070000000000000000000000000000000000000000575766666666666666667572
533333b307ccc700222022666622022222222222033333b007771170077701700088880000666600000000000000000000000000575766666666666666667572
333533337cc7cc70220066200266002222266222053333b000771170007001706888888666888866000000000000000000000000575766666666666666667572
3333b33307cc1cc7220666666666602226200262053333b007777710077707106888888668888886000000000000000000000000575766666666666666667572
33333333017ccc702206616666cc60222066c602003333300e07777020e077706588885668888886000000000000000000000000575766666666666666667572
b33333330107c7002208888888888022208888020333330020070e7022070e706655556666888866000000000000000000000000575766666666666666667572
33533b330000700022000000000000222000000205333bb022202202222022020066660000666600000000000000000000000000257766666666666666667722
aa0000aa00000000000000000000000022222222053333b000000000000000002222222200000000000000000000000000000000225766666666666666667222
a000000a000000000000000000000000222222220533333000000000000000002000222200000000000000000000000000000000225766666666666666667222
00000000000000000000000000000000222222227053300700000000000000000fff022200000000000000000000000000000000225776666666666666677222
00000000000000000000000000000000222222227700007700000000000000000ffff02200000000000000000000000000000000225577666666666666772222
00000000007000000008000000000000222222227704907700000000000000000fff0f0200000000000000000000000000000000222557777777777777722222
0000000007c70000008880000080800028888822702449070000000000000000200f002200000000000000000000000000000000222255555555555555222222
a000000a017c7000080808000008000020000022770200770000000000000000220f022200000000000000000000000000000000222222222222222222222222
aa0000aa010700000008000000808000222222227770777700000000000000002220222200000000000000000000000000000000222222222222222222222222
00000000222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00666600222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
065655608888822222228888222082222222822200000000aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000
05566660000022222220000022202222222082220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11556650222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
11155500222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000001010100000101010201010000000000010101000000000102000001000000000101010001010101000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
