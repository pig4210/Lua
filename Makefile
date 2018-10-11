# 这个 Makefile 用于使用 GNU make 在 Windows 编译 Lua LIB、DLL、EXE 等
# https://www.lua.org

# 如果只是单纯的 clean ，则无需 环境 和 路径
ifneq "$(MAKECMDGOALS)" "clean"

  # inc 的情况，无需环境
  ifeq "$(MAKECMDGOALS)" "inc"
  else ifeq "$(MAKECMDGOALS)" "clean inc"
  else ifeq "$(MAKECMDGOALS)" "inc clean"
  	$(error Are you kidding me ?!)
  else
    ifeq "$(filter x64 x86,$(Platform))" ""
      $(error Need VS Environment)
    endif
  endif

  ifeq "$(SRCPATH)" ""
    $(error Need SRCPATH)
  endif

endif


.PHONY : all
all : lib dll exe exec inc
	@echo make done.


######## 以下参考 src/Makefile ########
CORE_O=	lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o \
	lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o \
	ltm.o lundump.o lvm.o lzio.o
LIB_O=	lauxlib.o lbaselib.o lbitlib.o lcorolib.o ldblib.o liolib.o \
	lmathlib.o loslib.o lstrlib.o ltablib.o lutf8lib.o loadlib.o linit.o
BASE_O= $(CORE_O) $(LIB_O) $(MYOBJS)

lapi.o: lapi.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lstring.h \
 ltable.h lundump.h lvm.h
lauxlib.o: lauxlib.c lprefix.h lua.h luaconf.h lauxlib.h
lbaselib.o: lbaselib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lbitlib.o: lbitlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
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
lfunc.o: lfunc.c lprefix.h lua.h luaconf.h lfunc.h lobject.h llimits.h \
 lgc.h lstate.h ltm.h lzio.h lmem.h
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
 llimits.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h ltable.h lvm.h
lua.o: lua.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
luac.o: luac.c lprefix.h lua.h luaconf.h lauxlib.h lobject.h llimits.h \
 lstate.h ltm.h lzio.h lmem.h lundump.h ldebug.h lopcodes.h
lundump.o: lundump.c lprefix.h lua.h luaconf.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lstring.h lgc.h \
 lundump.h
lutf8lib.o: lutf8lib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lvm.o: lvm.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h lopcodes.h lstring.h \
 ltable.h lvm.h
lzio.o: lzio.c lprefix.h lua.h luaconf.h llimits.h lmem.h lstate.h \
 lobject.h ltm.h lzio.h
################################################


DESTPATH	:= $(Platform)

CC 			:= cl.exe
LINK		:= link.exe
AR			:= lib.exe

######## CFLAGS
CFLAGS		= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D WIN32 /D NDEBUG /D _UNICODE /D UNICODE /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo
CFLAGS		+= /D LUA_COMPAT_ALL /D LUA_COMPAT_5_2 /D LUA_COMPAT_5_1
CFLAGS		+= /I"$(SRCPATH)"
CFLAGS		+= /Fd"$(DESTPATH)/"
CFLAGS		+= /wd4244 /wd4310 /wd4324 /wd4702

ifeq "$(Platform)" "x86"
CFLAGS		+= /D _USING_V110_SDK71_
endif

CFLAGS		+= $(MyCFLAGS)

######## ARFLAGS
ARFLAGS		= /LTCG /ERRORREPORT:NONE /NOLOGO /MACHINE:$(Platform)
ARFLAGS		+= /LIBPATH:"$(DESTPATH)"

######## LDFLAGS
LDFLAGS		= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO /MACHINE:$(Platform)
LDFLAGS		+= /LIBPATH:"$(DESTPATH)"

ifeq "$(Platform)" "x86"
LDFLAGS_CONSOLE	:= /SAFESEH /SUBSYSTEM:CONSOLE",5.01"
LDFLAGS_WINDOWS	:= /SAFESEH /SUBSYSTEM:WINDOWS",5.01"
else
LDFLAGS_CONSOLE	:= /SUBSYSTEM:CONSOLE
LDFLAGS_WINDOWS	:= /SUBSYSTEM:WINDOWS
endif


# 源文件搜索路径
vpath %.c 	$(SRCPATH)
vpath %.h 	$(SRCPATH)
vpath %.hpp $(SRCPATH)

# 最终目标文件搜索路径
vpath %.lib $(DESTPATH)
vpath %.dll $(DESTPATH)
vpath %.exe $(DESTPATH)

vpath %.o 	$(DESTPATH)


######## INC
INCPATH			:= ./include
INCLUDES		:= lauxlib.h lua.h lua.hpp luaconf.h lualib.h
INCLUDES		:= $(INCLUDES:%=$(INCPATH)/%)

.PHONY : inc
inc : $(INCLUDES)

$(INCPATH) :
	@mkdir "$@"

$(INCPATH)/% : % | $(INCPATH)
	copy /y "$(?D)\\$(?F)" "$(@D)\\$(@F)"

######## 格式匹配规则
# 编译8
%.o : %.c | $(DESTPATH)
ifeq "$(MAKECMDGOALS)" "lua.lib"
	$(CC) $(CFLAGS) /D _LIB /Fo"$(DESTPATH)/$(@F)" "$<"
else ifeq "$(MAKECMDGOALS)" "luac.exe"
	$(CC) $(CFLAGS) /D _LIB /Fo"$(DESTPATH)/$(@F)" "$<"
else
	$(CC) $(CFLAGS) /D _USRDLL /D _WINDLL /D LUA_BUILD_AS_DLL /Fo"$(DESTPATH)/$(@F)" "$<"

lua.o : lua.c | $(DESTPATH)
	$(CC) $(CFLAGS) /Fo"$(DESTPATH)/$(@F)" "$<"
luac.o : luac.c | $(DESTPATH)
	$(CC) $(CFLAGS) /Fo"$(DESTPATH)/$(@F)" "$<"
endif


$(DESTPATH) :
	@mkdir "$@"

######## LIB
.PHONY : lib
lib :
	$(MAKE) SRCPATH="$(SRCPATH)" DESTPATH="$(DESTPATH)/lib" lua.lib --no-print-directory

lua.lib : $(BASE_O)
	$(AR) $(ARFLAGS) /OUT:"$(DESTPATH)/$(@F)" $^
	@copy /y "$(DESTPATH)\\$(@F)" "$(DESTPATH)/..\\$(@F)"

######## DLL
.PHONY : dll
dll :
	$(MAKE) SRCPATH="$(SRCPATH)" DESTPATH="$(DESTPATH)/dll" lua.dll --no-print-directory

lua.dll : $(BASE_O)
	$(LINK) $(LDFLAGS) /DLL $(LDFLAGS_WINDOWS) /OUT:"$(DESTPATH)/$(@F)" /IMPLIB:"$(DESTPATH)/dll.lib" $^
	@copy /y "$(DESTPATH)\\$(@F)" "$(DESTPATH)/..\\$(@F)"
	@copy /y "$(DESTPATH)\\dll.lib" "$(DESTPATH)/..\\dll.lib"

######## EXE
.PHONY : exe
exe :
	$(MAKE) SRCPATH="$(SRCPATH)" DESTPATH="$(DESTPATH)/dll" lua.exe --no-print-directory

lua.exe : lua.o lua.dll
	$(LINK) $(LDFLAGS) $(LDFLAGS_CONSOLE) /OUT:"$(DESTPATH)/$(@F)" $< dll.lib
	@copy /y "$(DESTPATH)\\$(@F)" "$(DESTPATH)/..\\$(@F)"

######## EXEC
.PHONY : exec
exec :
	$(MAKE) SRCPATH="$(SRCPATH)" DESTPATH="$(DESTPATH)/lib" luac.exe --no-print-directory

luac.exe : luac.o lua.lib
	$(LINK) $(LDFLAGS) $(LDFLAGS_CONSOLE) /OUT:"$(DESTPATH)/$(@F)" $^
	@copy /y "$(DESTPATH)\\$(@F)" "$(DESTPATH)/..\\$(@F)"

######## CLEAN
.PHONY : clean
clean :
	@if exist "x64" @rd /s /q "x64"
	@if exist "x86" @rd /s /q "x86"
	@if exist "include" @rd /s /q "include"