# 这个 Makefile 用于使用 GNU make 在 Windows 编译 Lua LIB、DLL、EXE 等
# https://www.lua.org

######## 以下参考 src/Makefile ########
CORE_O=	lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o
LIB_O=	lauxlib.o lbaselib.o lcorolib.o ldblib.o liolib.o lmathlib.o loadlib.o loslib.o lstrlib.o ltablib.o lutf8lib.o linit.o
BASE_O= $(CORE_O) $(LIB_O) $(MYOBJS)

lapi.o: lapi.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lstring.h \
 ltable.h lundump.h lvm.h
lauxlib.o: lauxlib.c lprefix.h lua.h luaconf.h lauxlib.h
lbaselib.o: lbaselib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lcode.o: lcode.c lprefix.h lua.h luaconf.h lcode.h llex.h lobject.h \
 llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
 ldo.h lgc.h lstring.h ltable.h lvm.h
lcorolib.o: lcorolib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lctype.o: lctype.c lprefix.h lctype.h lua.h luaconf.h llimits.h
ldblib.o: ldblib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
ldebug.o: ldebug.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h lcode.h llex.h lopcodes.h lparser.h \
 ldebug.h ldo.h lfunc.h lstring.h lgc.h ltable.h lvm.h
ldo.o: ldo.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lopcodes.h \
 lparser.h lstring.h ltable.h lundump.h lvm.h
ldump.o: ldump.c lprefix.h lua.h luaconf.h lobject.h llimits.h lstate.h \
 ltm.h lzio.h lmem.h lundump.h
lfunc.o: lfunc.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h
lgc.o: lgc.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h lstring.h ltable.h
linit.o: linit.c lprefix.h lua.h luaconf.h lualib.h lauxlib.h
liolib.o: liolib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
llex.o: llex.c lprefix.h lua.h luaconf.h lctype.h llimits.h ldebug.h \
 lstate.h lobject.h ltm.h lzio.h lmem.h ldo.h lgc.h llex.h lparser.h \
 lstring.h ltable.h
lmathlib.o: lmathlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lmem.o: lmem.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h
loadlib.o: loadlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lobject.o: lobject.c lprefix.h lua.h luaconf.h lctype.h llimits.h \
 ldebug.h lstate.h lobject.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h \
 lvm.h
lopcodes.o: lopcodes.c lprefix.h lopcodes.h llimits.h lua.h luaconf.h
loslib.o: loslib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lparser.o: lparser.c lprefix.h lua.h luaconf.h lcode.h llex.h lobject.h \
 llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
 ldo.h lfunc.h lstring.h lgc.h ltable.h
lstate.o: lstate.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h llex.h \
 lstring.h ltable.h
lstring.o: lstring.c lprefix.h lua.h luaconf.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h
lstrlib.o: lstrlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
ltable.o: ltable.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
ltablib.o: ltablib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
ltm.o: ltm.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
lua.o: lua.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
luac.o: luac.c lprefix.h lua.h luaconf.h lauxlib.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h lopcodes.h lopnames.h lundump.h
lundump.o: lundump.c lprefix.h lua.h luaconf.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lstring.h lgc.h \
 lundump.h
lutf8lib.o: lutf8lib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lvm.o: lvm.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h lopcodes.h lstring.h \
 ltable.h lvm.h ljumptab.h
lzio.o: lzio.c lprefix.h lua.h luaconf.h llimits.h lmem.h lstate.h \
 lobject.h ltm.h lzio.h
################################################
CFLAGS      += /DLUA_COMPAT_5_3 /wd4244 /wd4310 /wd4701 /wd4702 /wd4324

vpath %.c   $(SRCPATH)
vpath %.hpp $(SRCPATH)

######## INC
INCPATH     := ./include
INCLUDES    := lauxlib.h lua.h lua.hpp luaconf.h lualib.h
INCLUDES    := $(INCLUDES:%=$(INCPATH)/%)

.PHONY : inc
inc : $(INCLUDES)

$(INCPATH) :
	@mkdir "$@"

$(INCPATH)/% : % | $(INCPATH)
	copy /y "$(?D)\\$(?F)" "$(@D)\\$(@F)"

######## 格式匹配规则
# 编译
%.o : %.c | $(DSTPATH)
ifeq "$(MAKECMDGOALS)" "lua.lib"
	$(CC) $(CFLAGS) /D_LIB /Fo"$(DSTPATH)/$(@F)" "$<"
else ifeq "$(MAKECMDGOALS)" "luac.exe"
	$(CC) $(CFLAGS) /D_LIB /Fo"$(DSTPATH)/$(@F)" "$<"
else
	$(CC) $(CFLAGS) /D_USRDLL /D_WINDLL /DLUA_BUILD_AS_DLL /Fo"$(DSTPATH)/$(@F)" "$<"

lua.o : lua.c | $(DSTPATH)
	$(CC) $(CFLAGS) /Fo"$(DSTPATH)/$(@F)" "$<"
luac.o : luac.c | $(DSTPATH)
	$(CC) $(CFLAGS) /Fo"$(DSTPATH)/$(@F)" "$<"
endif


######## LIB
.PHONY : lib
lib :
	$(MAKE) SRCPATH="$(SRCPATH)" DSTPATH="$(DSTPATH)/lib" lua.lib --no-print-directory

lua.lib : $(BASE_O)
	$(AR) $(ARFLAGS) /OUT:"$(DSTPATH)/$(@F)" $^
	@copy /y "$(DSTPATH)\\$(@F)" "$(DSTPATH)/..\\$(@F)"

######## DLL
.PHONY : dll
dll :
	$(MAKE) SRCPATH="$(SRCPATH)" DSTPATH="$(DSTPATH)/dll" lua.dll --no-print-directory

lua.dll : $(BASE_O)
	$(LINK) $(LDFLAGS) /DLL $(LDFLAGS_WINDOWS) /OUT:"$(DSTPATH)/$(@F)" /IMPLIB:"$(DSTPATH)/dll.lib" $^
	@copy /y "$(DSTPATH)\\$(@F)" "$(DSTPATH)/..\\$(@F)"
	@copy /y "$(DSTPATH)\\dll.lib" "$(DSTPATH)/..\\dll.lib"

######## EXE
.PHONY : exe
exe :
	$(MAKE) SRCPATH="$(SRCPATH)" DSTPATH="$(DSTPATH)/dll" lua.exe --no-print-directory

lua.exe : lua.o lua.dll
	$(LINK) $(LDFLAGS) $(LDFLAGS_CONSOLE) /OUT:"$(DSTPATH)/$(@F)" $< dll.lib
	@copy /y "$(DSTPATH)\\$(@F)" "$(DSTPATH)/..\\$(@F)"

######## EXEC
.PHONY : exec
exec :
	$(MAKE) SRCPATH="$(SRCPATH)" DSTPATH="$(DSTPATH)/lib" luac.exe --no-print-directory

luac.exe : luac.o lua.lib
	$(LINK) $(LDFLAGS) $(LDFLAGS_CONSOLE) /OUT:"$(DSTPATH)/$(@F)" $^
	@copy /y "$(DSTPATH)\\$(@F)" "$(DSTPATH)/..\\$(@F)"

######## ALL
all :   lib   dll   exe   exec   inc
	@echo make done.