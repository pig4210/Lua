@echo off

:begin
    setlocal
    set MyPath=%~dp0

:config
    if "%1" == "" (
      set PLAT=x64
    ) else (
      set PLAT=x86
    )

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\lua-5.3.4\\src
    set GPATH=%MyPath%\\%PLAT%

    set CC=cl
    set AR=lib
    set LNK=link

:compileflags
    set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo /Fo"%GPATH%\\"

    set MyCFLAGS= /wd"4244" /wd"4310" /wd"4324" /wd"4702" /D "LUA_COMPAT_ALL" /D"LUA_COMPAT_5_2" /D"LUA_COMPAT_5_1"

    if not "%1" == "" set MyCFLAGS=%MyCFLAGS% /D "_USING_V110_SDK71_"

:linkflags
    if "%1" == "" (
        set LFLAGS_PLAT_CONSOLE= /SUBSYSTEM:CONSOLE
        set LFLAGS_PLAT_WINDOWS= /SUBSYSTEM:WINDOWS
    ) else (
        set LFLAGS_PLAT_CONSOLE= /SAFESEH /SUBSYSTEM:CONSOLE",5.01"
        set LFLAGS_PLAT_WINDOWS= /SAFESEH /SUBSYSTEM:WINDOWS",5.01"
    )

    set LFLAGS= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /MACHINE:%PLAT% /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO

:makeinclude
    set IncludePath=%MyPath%\include

    if not "%1" == "" (
      echo ==== ==== ==== ==== Prepare Include Folder and Files...
      rd /S /Q "%IncludePath%"
      mkdir "%IncludePath%"

      cd /d %VPATH%
      copy "lauxlib.h"  "%IncludePath%\\" >nul
      copy "lua.h"      "%IncludePath%\\" >nul
      copy "lua.hpp"    "%IncludePath%\\" >nul
      copy "luaconf.h"  "%IncludePath%\\" >nul
      copy "lualib.h"   "%IncludePath%\\" >nul

      echo.
    )

:start
    echo ==== ==== ==== ==== Start compiling %PLAT%...

    echo ==== ==== ==== ==== Prepare environment(%PLAT%)...
    cd /d %VCPATH%
    if "%1" == "" (
        call vcvarsall.bat amd64 >nul
    ) else (
        call vcvarsall.bat x86 >nul
    )

    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...
    if not exist "%GPATH%" mkdir %GPATH%
    del /q "%GPATH%\\*.*"

    cd /d %VPATH%

:lib
    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lualib.pdb" /D "_LIB" "%VPATH%\\*.c" >nul
    if not %errorlevel%==0 goto compile_error

    del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"

    %AR% /OUT:"%GPATH%\\lualib.lib" /LTCG /MACHINE:%PLAT% /NOLOGO "%GPATH%\\*.obj" >nul
    if not %errorlevel%==0 goto link_error

    del "%GPATH%\\*.obj"

:dll
    echo ==== ==== ==== ==== Building DLL(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luadll.pdb" /D "_USRDLL" /D "_WINDLL" /D "LUA_BUILD_AS_DLL" *.c >nul
    if not %errorlevel%==0 goto compile_error

    del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"
  
    %LNK% /DLL /OUT:"%GPATH%\\lua.dll" %LFLAGS% %LFLAGS_PLAT_WINDOWS% /IMPLIB:"%GPATH%\\lua.lib" "%GPATH%\\*.obj" >nul
    if not %errorlevel%==0 goto link_error

:exe
    echo ==== ==== ==== ==== Building EXE(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lua.pdb" "%VPATH%\\lua.c" >nul
    if not %errorlevel%==0 goto compile_error

    %LNK% /OUT:"%GPATH%\\lua.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\lua.obj" >nul
    if not %errorlevel%==0 goto link_error

:exec
    echo ==== ==== ==== ==== Building Luac(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luac.pdb" "%VPATH%\\luac.c" >nul
    if not %errorlevel%==0 goto compile_error

    %LNK% /OUT:"%GPATH%\\luac.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\luac.obj" >nul
    if not %errorlevel%==0 goto link_error

:dllexe
    echo ==== ==== ==== ==== Building DllExe(%PLAT%)...

    %LNK% /OUT:"%GPATH%\\luadll.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lua.lib" "%GPATH%\\lua.obj" >nul
    if not %errorlevel%==0 goto link_error

:done
    del "%GPATH%\\*.obj"
    echo.

    endlocal

    if "%1" == "" (
        cmd /C %~f0 x86
    ) else (
        exit /B 0
    )

    echo done.

    goto end

:compile_error
    echo !!!!!!!!Compile error!!!!!!!!
    goto end

:link_error
    echo !!!!!!!!Link error!!!!!!!!
    goto end

:end
    pause >nul