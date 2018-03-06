@echo off
setlocal

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86
set MyPath=%~dp0

rem ==== ==== 以下仿MakeFile定义宏 ==== ====
set VCPath=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
set VPATH=%MyPath%\\lua-5.3.4\\src
set GPATH=%MyPath%\\%PLAT%

set CC=cl
set AR=lib
set LINK=link

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

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo /Fo"%GPATH%\\"

set MyCFLAGS= /wd"4244" /wd"4310" /wd"4324" /wd"4702" /D "LUA_COMPAT_ALL" /D"LUA_COMPAT_5_2" /D"LUA_COMPAT_5_1"

if not "%1" == "" set MyCFLAGS=%MyCFLAGS% /D "_USING_V110_SDK71_"

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

if "%1" == "" set LFLAGS_PLAT_CONSOLE= /SUBSYSTEM:CONSOLE
if not "%1" == "" set LFLAGS_PLAT_CONSOLE= /SAFESEH /SUBSYSTEM:CONSOLE",5.01" 

if "%1" == "" set LFLAGS_PLAT_WINDOWS= /SUBSYSTEM:WINDOWS
if not "%1" == "" set LFLAGS_PLAT_WINDOWS= /SAFESEH /SUBSYSTEM:WINDOWS",5.01" 

set LFLAGS= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /MACHINE:%PLAT% /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO

set IncludePath=%MyPath%\include

if not "%1" == "" echo ==== ==== ==== ==== Include文件准备...
if not "%1" == "" rd /S /Q "%IncludePath%"
if not "%1" == "" mkdir "%IncludePath%"
if not "%1" == "" copy "%VPATH%\\lauxlib.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lua.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lua.hpp" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\luaconf.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lualib.h" "%IncludePath%\\" >nul

echo ==== ==== ==== ==== 开始编译%PLAT%...

echo ==== ==== ==== ==== 准备编译环境(%PLAT%)...
cd /d %VCPath%
if "%1" == "" call vcvarsall.bat amd64 >nul
if not "%1" == "" call vcvarsall.bat x86 >nul

echo ==== ==== ==== ==== 准备目标目录(%PLAT%)...
if not exist "%GPATH%" mkdir %GPATH%
del /q "%GPATH%\\*.*"

cd /d %VPATH%

echo ==== ==== ==== ==== 编译并生成LIB(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lualib.pdb" /D "_LIB" "%VPATH%\\*.c" >nul

if not %errorlevel%==0 goto compile_error

del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"

%AR% /OUT:"%GPATH%\\lualib.lib" /LTCG /MACHINE:%PLAT% /NOLOGO "%GPATH%\\*.obj" >nul

if not %errorlevel%==0 goto link_error

del "%GPATH%\\*.obj"

echo ==== ==== ==== ==== 编译并生成DLL(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luadll.pdb" /D "_USRDLL" /D "_WINDLL" /D "LUA_BUILD_AS_DLL" *.c >nul

if not %errorlevel%==0 goto compile_error

del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"

%LINK% /OUT:"%GPATH%\\lua.dll" %LFLAGS% %LFLAGS_PLAT_WINDOWS% /IMPLIB:"%GPATH%\\lua.lib" /DLL "%GPATH%\\*.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== 编译并生成EXE(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lua.pdb" "%VPATH%\\lua.c" >nul

if not %errorlevel%==0 goto compile_error

%LINK% /OUT:"%GPATH%\\lua.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\lua.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== 编译并生成Luac(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luac.pdb" "%VPATH%\\luac.c" >nul

if not %errorlevel%==0 goto compile_error

%LINK% /OUT:"%GPATH%\\luac.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\luac.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== 编译并生成DllExe(%PLAT%)...

%LINK% /OUT:"%GPATH%\\luadll.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lua.lib" "%GPATH%\\lua.obj" >nul

if not %errorlevel%==0 goto link_error

rem ==== ==== ==== ====

del "%GPATH%\\*.obj"

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo 完成

goto end

:compile_error
echo !!!!!!!!编译失败!!!!!!!!
goto end

:link_error
echo !!!!!!!!链接失败!!!!!!!!
goto end

:end

pause >nul