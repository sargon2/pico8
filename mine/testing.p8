pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
// enable character wrapping
poke(0x5f36, peek(0x5f36) | 128)

function report(result, msg)
 msg = msg or ""
 res = ""
 if result then
  res ..= "\fbpass\f6"
 else
  res ..= "\f8fail\f6"
  printh("")
  printh("trace: "..trace())
  res ..= "; " .. msg
  printh("test msg: "..msg)
 end
 print(res)
 if not result then
  stop()
 end
end

function assert(val, msg)
 report(val, msg)
end

function assertequal(a, b, fmsg)
 fmsg = fmsg or ""
 assert(a == b, a.." != "..b.."; "..fmsg)
end

function assertnotequal(a, b, fmsg)
 fmsg = fmsg or ""
 assert(a != b, a.." == "..b.."; "..fmsg)
end

function test_something()
 assertequal(1, 1)
 assertequal(2, 2)
end

function test_something_else()
 assertequal(1, 1)
 assertnotequal(1, 1, "expected failure")
end

function run_test(name, fn)
 print("")
 print(name..":")
 fn()
end

function run_tests()
 run_test("test_something", test_something)
 run_test("test_something_else", test_something_else)
 print("\fbend of tests! all passed")
end

run_tests()
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
