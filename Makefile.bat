@echo off
setlocal

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86
set MyPath=%~dp0

rem ==== ==== ���·�MakeFile����� ==== ====
set VCPath=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
set VPATH=%MyPath%\\lua-5.3.4\\src
set GPATH=%MyPath%\\%PLAT%

set CC=cl
set AR=lib
set LINK=link

rem /c      ֻ����
rem /MP     ���̱߳���
rem /GS-    ���ð�ȫ���
rem /Qpar   ���д���
rem /GL     ����ʱ��������
rem /analyze-   ���ñ�������
rem /W4     4������
rem /Gy     �ָ�����������
rem /Zi     ���õ�����Ϣ
rem /Gm-    �ر���С��������
rem /Ox     ����Ż�
rem /Fd     PDB�ļ����
rem /fp     ����
rem /errorReprot    �޴��󱨸�
rem /GF     �ַ�����
rem /WX-    �رվ������
rem /Zc-    ǿ��C++��׼
rem /GR-    �ر�RTTI
rem /Gd     Ĭ�ϵ���Լ�� cdecl
rem /Oy     ʡ��ָ֡��
rem /Oi     �����ڲ�����
rem /MT     ����ʱ
rem /Eha    C++�쳣
rem /Fo     ���

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo /Fo"%GPATH%\\"

set MyCFLAGS= /wd"4244" /wd"4310" /wd"4324" /wd"4702" /D "LUA_COMPAT_ALL" /D"LUA_COMPAT_5_2" /D"LUA_COMPAT_5_1"

if not "%1" == "" set MyCFLAGS=%MyCFLAGS% /D "_USING_V110_SDK71_"

rem /MANIFEST:NO    �������嵥
rem /LTCG           ����ʱ���������
rem /NXCOMPAT       ����ִ�б���
rem /DYNAMICBASE    �����ַ
rem /MACHINE        x86/x64
rem /OPT            REF���� ICF�۵�
rem /SAFESEH        ��ȫ�쳣����
rem /SUBSYSTEM      ��ϵͳ
rem /INCREMENTAL    ������������
rem /ERRORREPORT    ���󱨸�

if "%1" == "" set LFLAGS_PLAT_CONSOLE= /SUBSYSTEM:CONSOLE
if not "%1" == "" set LFLAGS_PLAT_CONSOLE= /SAFESEH /SUBSYSTEM:CONSOLE",5.01" 

if "%1" == "" set LFLAGS_PLAT_WINDOWS= /SUBSYSTEM:WINDOWS
if not "%1" == "" set LFLAGS_PLAT_WINDOWS= /SAFESEH /SUBSYSTEM:WINDOWS",5.01" 

set LFLAGS= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /MACHINE:%PLAT% /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO

set IncludePath=%MyPath%\include

if not "%1" == "" echo ==== ==== ==== ==== Include�ļ�׼��...
if not "%1" == "" rd /S /Q "%IncludePath%"
if not "%1" == "" mkdir "%IncludePath%"
if not "%1" == "" copy "%VPATH%\\lauxlib.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lua.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lua.hpp" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\luaconf.h" "%IncludePath%\\" >nul
if not "%1" == "" copy "%VPATH%\\lualib.h" "%IncludePath%\\" >nul

echo ==== ==== ==== ==== ��ʼ����%PLAT%...

echo ==== ==== ==== ==== ׼�����뻷��(%PLAT%)...
cd /d %VCPath%
if "%1" == "" call vcvarsall.bat amd64 >nul
if not "%1" == "" call vcvarsall.bat x86 >nul

echo ==== ==== ==== ==== ׼��Ŀ��Ŀ¼(%PLAT%)...
if not exist "%GPATH%" mkdir %GPATH%
del /q "%GPATH%\\*.*"

cd /d %VPATH%

echo ==== ==== ==== ==== ���벢����LIB(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lualib.pdb" /D "_LIB" "%VPATH%\\*.c" >nul

if not %errorlevel%==0 goto compile_error

del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"

%AR% /OUT:"%GPATH%\\lualib.lib" /LTCG /MACHINE:%PLAT% /NOLOGO "%GPATH%\\*.obj" >nul

if not %errorlevel%==0 goto link_error

del "%GPATH%\\*.obj"

echo ==== ==== ==== ==== ���벢����DLL(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luadll.pdb" /D "_USRDLL" /D "_WINDLL" /D "LUA_BUILD_AS_DLL" *.c >nul

if not %errorlevel%==0 goto compile_error

del "%GPATH%\\lua.obj" "%GPATH%\\luac.obj"

%LINK% /OUT:"%GPATH%\\lua.dll" %LFLAGS% %LFLAGS_PLAT_WINDOWS% /IMPLIB:"%GPATH%\\lua.lib" /DLL "%GPATH%\\*.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== ���벢����EXE(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\lua.pdb" "%VPATH%\\lua.c" >nul

if not %errorlevel%==0 goto compile_error

%LINK% /OUT:"%GPATH%\\lua.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\lua.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== ���벢����Luac(%PLAT%)...

%CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\luac.pdb" "%VPATH%\\luac.c" >nul

if not %errorlevel%==0 goto compile_error

%LINK% /OUT:"%GPATH%\\luac.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lualib.lib" "%GPATH%\\luac.obj" >nul

if not %errorlevel%==0 goto link_error

echo ==== ==== ==== ==== ���벢����DllExe(%PLAT%)...

%LINK% /OUT:"%GPATH%\\luadll.exe" %LFLAGS% %LFLAGS_PLAT_CONSOLE% "%GPATH%\\lua.lib" "%GPATH%\\lua.obj" >nul

if not %errorlevel%==0 goto link_error

rem ==== ==== ==== ====

del "%GPATH%\\*.obj"

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo ���

goto end

:compile_error
echo !!!!!!!!����ʧ��!!!!!!!!
goto end

:link_error
echo !!!!!!!!����ʧ��!!!!!!!!
goto end

:end

pause >nul