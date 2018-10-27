#!/usr/bin/lua

---------------------------------
local build = ' gcc -Wall -O2 -std=c99 -DLUA_USE_LINUX -DLUA_USE_READLINE -I ./ -o lua lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c lzio.c ltests.c lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c ltablib.c lstrlib.c lutf8lib.c loadlib.c lcorolib.c linit.c lua.c -lm -ldl -lreadline '
os.execute('rm -fR lua-origin')
os.execute('git clone ./ lua-origin/')
os.execute('cd lua-origin/; git checkout f59e6a93c0ad38a27a420e51abf8f13d962446b5 ')
print'compiling'
local ok = os.execute(' cd lua-origin; '..build)
assert(ok == true)
local ok = os.execute(build)
assert(ok == true)

---------------------------------
print'testing'

local function luarun(str)
  if not os.execute("./lua -e '"..str.."'") then
    os.exit()
  end
end

luarun[===[ t={} t[1]=[[]] print(#t) assert(#t==1) ]===]
luarun[===[ t={} t[8]=[[]] print(#t) assert(#t==8) ]===]
luarun[===[ t={} t[99999]=[[]] print(#t) assert(#t==99999) ]===]
luarun[===[ t={} t[99999]=nil print(#t) assert(#t==99999) ]===]
luarun[===[ t={} t[-1]=[[]] print(#t) assert(#t==0) ]===]
luarun[===[ t={} t[-99999]=[[]] print(#t) assert(#t==0) ]===]
luarun[===[ t={} rawset(t,8,[[]]) print(#t) assert(#t==8) ]===]
luarun[===[ t={} rawset(t,-99999,[[]]) print(#t) assert(#t==0) ]===]
luarun[===[ t={1,2,3} print(#t) assert(#t==3) ]===]
luarun[===[ t={0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,} print(#t) assert(#t==520) ]===]
luarun[===[ t={0,nil,nil,0} print(#t) assert(#t==4) ]===]
luarun[===[ t={0,0,nil,nil} print(#t) assert(#t==4) ]===]
luarun[===[ t={(function()return 0,nil,nil,0 end)()} print(#t) assert(#t==4) ]===]
luarun[===[ t={(function()return 0,0,nil,nil end)()} print(#t) assert(#t==4) ]===]
luarun[===[ t=(function(...)return {...} end)(1,nil,nil,4,nil,nil,nil) print(#t) assert(#t==7) ]===]
luarun[===[ t={} t[3]=[[]] print(#t) assert(#t==3) setmetatable(t,{__len=function()return 666 end}) print(#t) assert(#t==666) ]===]
luarun[===[ t={} table.setlen(t, 3) print(#t) assert(#t==3) ]===]
luarun[===[ t={1,2,3,4} table.setlen(t, 2) print(#t) assert(#t==2) ]===]
luarun[===[ t={ 1,2,nil,nil,5,6 } print(t) for k,v in ipairs(t) do print(k,v) end ]===]
luarun[===[ a,b,c,d,e,f,g,h,i=table.unpack({nil,nil,nil,nil,nil,nil,nil,nil,9}) print(i)assert(i==9) ]===]
luarun[===[ t=table.pack(1,2,nil,nil,5,6,nil,nil) print(#t)assert(#t==8) ]===]
luarun[===[ t={} table.move({1,2,3},1,3,10,t) print(#t)assert(#t==12) ]===]
luarun[===[ t={} table.insert(t,[[a]]) print(#t)assert(#t==1) table.insert(t,1,[[a]]) print(#t)assert(#t==2) ]===]

---------------------------------
print'benchmarking'
for i=1,10 do
  local bm = ' local t = {1,2,3} local s = os.clock() for i=1,9999999 do t[i] = {} end print([[time]],os.clock()-s)print([[memory]],collectgarbage[[count]]) '
  print'---------'
  print'origin'
  ok = os.execute("./lua-origin/lua -e '"..bm.."' > tmp.txt")
  if not ok then return end
  local r = io.open('tmp.txt','r'):read('a')
  print(r)
  local t = tonumber((r:match('time\t([^\n]*)')))
  local m = tonumber((r:match('memory\t([^\n]*)')))
  print'---------'
  print'patched'
  ok = os.execute("./lua -e '"..bm.."' > tmp.txt")
  if not ok then return end
  local r = io.open('tmp.txt','r'):read('a')
  print(r)
  local T = tonumber((r:match('time\t([^\n]*)')))
  local M = tonumber((r:match('memory\t([^\n]*)')))
  print'---------'
  print'patched/origin'
  print('time',T/t)
  print('memory',M/m)
  print()
end

