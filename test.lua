#!/usr/bin/lua

-----------------------
-- util

local lua_bin = 'lua.exe'--'./lua'
local comp_opt_a = ''--' -DLUA_USE_LINUX -DLUA_USE_READLINE '
local comp_opt_b = ''--' -ldl -lreadline '

local tmp_fil = "tmp.txt"

local function cmdrun(cmd, out)
  if out then
    cmd = cmd .. [[ > ]] .. tmp_fil
  end
  print('debug # ',cmd)
  if not os.execute(cmd) then
    os.exit()
  end
  if out then
    local r = io.open(tmp_fil,'r'):read('a')
    print(r)
    return r
  end
end

tmp_fil = cmdrun([[ echo %cd% ]], true) --cmdrun([[ pwd ]], true)
tmp_fil = tmp_fil:gsub('[\n\r\t ]*$','') .. '/tmp.txt'
print('Auxiliary file:', tmp_fil)

local function luarun(str, dir, out)
  local cmd = lua_bin..[[ -e "]]..str..[["]]
  if dir then
    cmd = [[ cd ]] .. dir .. [[ && ]] .. cmd
  end
  return cmdrun(cmd, out)
end

local function makeMeasure()
  local sum = 0
  local square = 0
  local sample = 0
  return function(m)
    sample = sample + 1
    sum = sum + m
    square = square + m * m
    return sum/sample, math.sqrt((square-sum*sum/sample)/(sample-1))
  end
end

---------------------------------
print'compiling'
local build = ' gcc -Wall -O2 -std=c99 -I ./ '..comp_opt_a..' -o '..lua_bin..' lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c lzio.c ltests.c lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c ltablib.c lstrlib.c lutf8lib.c loadlib.c lcorolib.c linit.c lua.c -lm '..comp_opt_b
-- os.execute('rm -fR lua-origin')
-- os.execute('git clone ./ lua-origin/')
-- os.execute('cd lua-origin/; git checkout f59e6a93c0ad38a27a420e51abf8f13d962446b5 ')
-- local ok = os.execute(' cd lua-origin ; '..build)
-- assert(ok == true)
local ok = os.execute(build)
assert(ok == true)

---------------------------------
print'testing'

luarun[===[ t={} t[1]=[[]] print(#t) assert(#t==1) ]===]
luarun[===[ t={} t[8]=[[]] print(#t) assert(#t==0) ]===]
luarun[===[ t={} t[1]=nil print(#t) assert(#t==1) ]===]
luarun[===[ t={} t[8]=nil print(#t) assert(#t==0) ]===]
luarun[===[ t={} t[-1]=[[]] print(#t) assert(#t==0) ]===]
luarun[===[ t={} t[-8]=[[]] print(#t) assert(#t==0) ]===]
luarun[===[ t={} rawset(t,1,[[]]) print(#t) assert(#t==1) ]===]
luarun[===[ t={} rawset(t,8,[[]]) print(#t) assert(#t==0) ]===]
luarun[===[ t={} rawset(t,-8,[[]]) print(#t) assert(#t==0) ]===]
luarun[===[ t={} t[1]=0 t[2]=0 print(#t) assert(#t==2) ]===]
luarun[===[ t={} t[1]=0 t[2]=0 t[2]=nil print(#t) assert(#t==2) ]===]
luarun[===[ t={1,2,3} print(#t) assert(#t==3) ]===]
luarun[===[ t={0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,} print(#t) assert(#t==520) ]===]
luarun[===[ t={0,nil,nil,0} print(#t) assert(#t==4) ]===]
luarun[===[ t={0,0,nil,nil} print(#t) assert(#t==4) ]===]
luarun[===[ t={(function()return 0,nil,nil,0 end)()} print(#t) assert(#t==4) ]===]
luarun[===[ t={(function()return 0,0,nil,nil end)()} print(#t) assert(#t==4) ]===]
luarun[===[ t=(function(...)return {...} end)(1,nil,nil,4,nil,nil,nil) print(#t) assert(#t==7) ]===]
luarun[===[ t={1,2,3} print(#t) assert(#t==3) setmetatable(t,{__len=function()return 666 end}) print(#t) assert(#t==666) ]===]
luarun[===[ t={} table.setlen(t, 3) print(#t) assert(#t==3) ]===]
luarun[===[ t={1,2,3,4} table.setlen(t, 2) print(#t) assert(#t==2) ]===]
luarun[===[ t={ 1,2,nil,nil,5,6 } print(t) for k,v in ipairs(t) do print(k,v) end ]===]
luarun[===[ a,b,c,d,e,f,g,h,i=table.unpack({nil,nil,nil,nil,nil,nil,nil,nil,9}) print(i)assert(i==9) ]===]
luarun[===[ t={} table.insert(t,[[a]]) print(#t)assert(#t==1) table.insert(t,1,[[a]]) print(#t)assert(#t==2) ]===]
luarun[===[ t={1,2,3,4} table.move({1,2,3},1,3,5,t) print(#t)assert(#t==7) ]===]
luarun[===[ t={1,2,3,4} table.move(t,1,4,3,t) print(#t)assert(#t==6) ]===]
luarun[===[ t=table.pack(1,2,nil,nil,5,6,nil,nil) print(#t)assert(#t==8) ]===]

---------------------------------
local time = makeMeasure()
local memory = makeMeasure()
print'benchmarking'
for i=1,100 do
  local bm = ' print(_VERSION) local t = {1,2,3} local s = os.clock() for i=1,999999 do t[i] = {} end print([[time]],os.clock()-s)print([[memory]],collectgarbage[[count]]) '
  print'---------'
  local r = luarun(bm, 'lua-origin', true)
  assert('5.4' == r:match('Lua ([^\n\r]*)'))
  print'---------'
  local R = luarun(bm, nil, true)
  assert('5.4p' == R:match('Lua ([^\n\r]*)'))
  print'---------'
  local t = tonumber((r:match('time\t([^\n\r]*)')))
  local m = tonumber((r:match('memory\t([^\n\r]*)')))
  local T = tonumber((R:match('time\t([^\n\r]*)')))
  local M = tonumber((R:match('memory\t([^\n\r]*)')))
  print'patched/origin'
  print('time ratio',T/t)
  print('memory ratio',M/m)
  local a,b = time((T-t)/t)
  print('delta time',a..' +- '..b)
  local a,b = memory((M-m)/m)
  print('delta memory',a..' +- '..b)
  print()
end

-----------------
print('press [enter] to quit...')
io.read(1)

