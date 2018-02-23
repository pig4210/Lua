
@echo off
rem nmake不支持VPATH，使用makefile并不方便，必须进入源代码目录。前缀路径无法触发默认编译。所以放弃makefile，采用批处理
setlocal
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set LuaSrcPath=.\lua-5.3.4\src

set MyPath=%~dp0
set IncludePath=%MyPath%\include

if not exist "%IncludePath%" mkdir %IncludePath%
if "%1" == "" echo 准备include文件...
if "%1" == "" del /q "%IncludePath%\\*.*"
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lauxlib.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lua.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lua.hpp" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\luaconf.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lualib.h" "%IncludePath%\\" >nul

cd /d %VCPath%

if "%1" == "" @set PLAT=x64
if not "%1" == "" @set PLAT=x86

echo 开始编译%PLAT%...

if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

rem ==== ==== ==== ====
set OutPath=%MyPath%\%PLAT%
if not exist "%OutPath%" mkdir %OutPath%
del /q "%OutPath%\\*.*"

cd /d %MyPath%\%LuaSrcPath%

rem /c      只编译
rem /MP     多线程编译
rem /GS-    禁用安全检查
rem /Qpar   并行代码
rem /GL     链接时代码生成
rem /analyze-   禁用本机分析
rem /W4     4级警告
rem /Gy     分隔链接器函数
rem /Zi     启用调试信息
rem /Gm-    关闭最小重新生成
rem /Ox     最大优化
rem /Fd     PDB文件输出
rem /fp     浮点
rem /errorReprot    无错误报告
rem /GF     字符串池
rem /WX-    关闭警告错误
rem /Zc-    强制C++标准
rem /GR-    关闭RTTI
rem /Gd     默认调用约定 cdecl
rem /Oy     省略帧指针
rem /Oi     启用内部函数
rem /MT     运行时
rem /Eha    C++异常
rem /Fo     输出

if "%1" == "" set CFLAGS_PLAT=
if not "%1" == "" set CFLAGS_PLAT= /D "_USING_V110_SDK71_"

set MyCFLAGS= /wd"4244" /wd"4310" /wd"4324" /wd"4702" /D "LUA_COMPAT_ALL" /D"LUA_COMPAT_5_2" /D"LUA_COMPAT_5_1"

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo /Fo"%OutPath%\\" %CFLAGS_PLAT% %MyCFLAGS%

rem ==== ==== ==== ====
echo 编译%PLAT% lib中...

cl %CFLAGS% /Fd"%OutPath%\\lualib.pdb" /D "_LIB" *.c >nul

if not %errorlevel%==0 echo !!!!!!!!编译失败!!!!!!!! && goto end

del "%OutPath%\\lua.obj" "%OutPath%\\luac.obj"

lib /OUT:"%OutPath%\\lualib.lib" /LTCG /MACHINE:%PLAT% /NOLOGO "%OutPath%\\*.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!链接失败!!!!!!!! && goto end

rem ==== ==== ==== ====

del "%OutPath%\\*.obj"

rem /MANIFEST:NO    不生成清单
rem /LTCG           链接时间代码生成
rem /NXCOMPAT       数据执行保护
rem /DYNAMICBASE    随机基址
rem /MACHINE        x86/x64
rem /OPT            REF引用 ICF折叠
rem /SAFESEH        安全异常处理
rem /SUBSYSTEM      子系统
rem /INCREMENTAL    禁用增量连接
rem /ERRORREPORT    错误报告

if "%1" == "" set LINKFLAGS_PLAT_CONSOLE= /SUBSYSTEM:CONSOLE
if not "%1" == "" set LINKFLAGS_PLAT_CONSOLE= /SAFESEH /SUBSYSTEM:CONSOLE",5.01" 

if "%1" == "" set LINKFLAGS_PLAT_WINDOWS= /SUBSYSTEM:WINDOWS
if not "%1" == "" set LINKFLAGS_PLAT_WINDOWS= /SAFESEH /SUBSYSTEM:WINDOWS",5.01" 

set LINKFLAGS= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /MACHINE:%PLAT% /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO

rem ==== ==== ==== ====
echo 编译%PLAT% dll中...

cl %CFLAGS% /Fd"%OutPath%\\luadll.pdb" /D "_USRDLL" /D "_WINDLL" /D "LUA_BUILD_AS_DLL" *.c >nul

if not %errorlevel%==0 echo !!!!!!!!编译失败!!!!!!!! && goto end

del "%OutPath%\\lua.obj" "%OutPath%\\luac.obj"

link /OUT:"%OutPath%\\lua.dll" %LINKFLAGS% %LINKFLAGS_PLAT_WINDOWS% /IMPLIB:"%OutPath%\\lua.lib" /DLL "%OutPath%\\*.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!链接失败!!!!!!!! && goto end

rem ==== ==== ==== ====
echo 编译%PLAT% exe中...

cl %CFLAGS% /Fd"%OutPath%\\lua.pdb" lua.c >nul

if not %errorlevel%==0 echo !!!!!!!!编译失败!!!!!!!! && goto end

link /OUT:"%OutPath%\\lua.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lualib.lib" "%OutPath%\\lua.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!链接失败!!!!!!!! && goto end

rem ==== ==== ==== ====
echo 编译%PLAT% exec中...

cl %CFLAGS% /Fd"%OutPath%\\luac.pdb" luac.c >nul

if not %errorlevel%==0 echo !!!!!!!!编译失败!!!!!!!! && goto end

link /OUT:"%OutPath%\\luac.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lualib.lib" "%OutPath%\\luac.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!链接失败!!!!!!!! && goto end

rem ==== ==== ==== ====
echo 编译%PLAT% dll exe中...

link /OUT:"%OutPath%\\luadll.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lua.lib" "%OutPath%\\lua.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!链接失败!!!!!!!! && goto end

rem ==== ==== ==== ====

del "%OutPath%\\*.obj"

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo 完成
:end

pause >nul