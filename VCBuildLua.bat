
@echo off
rem nmake��֧��VPATH��ʹ��makefile�������㣬�������Դ����Ŀ¼��ǰ׺·���޷�����Ĭ�ϱ��롣���Է���makefile������������
setlocal
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set LuaSrcPath=.\lua-5.3.4\src

set MyPath=%~dp0
set IncludePath=%MyPath%\include

if not exist "%IncludePath%" mkdir %IncludePath%
if "%1" == "" echo ׼��include�ļ�...
if "%1" == "" del /q "%IncludePath%\\*.*"
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lauxlib.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lua.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lua.hpp" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\luaconf.h" "%IncludePath%\\" >nul
if "%1" == "" copy "%MyPath%\\%LuaSrcPath%\\lualib.h" "%IncludePath%\\" >nul

cd /d %VCPath%

if "%1" == "" @set PLAT=x64
if not "%1" == "" @set PLAT=x86

echo ��ʼ����%PLAT%...

if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

rem ==== ==== ==== ====
set OutPath=%MyPath%\%PLAT%
if not exist "%OutPath%" mkdir %OutPath%
del /q "%OutPath%\\*.*"

cd /d %MyPath%\%LuaSrcPath%

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

if "%1" == "" set CFLAGS_PLAT=
if not "%1" == "" set CFLAGS_PLAT= /D "_USING_V110_SDK71_"

set MyCFLAGS= /wd"4244" /wd"4310" /wd"4324" /wd"4702" /D "LUA_COMPAT_ALL" /D"LUA_COMPAT_5_2" /D"LUA_COMPAT_5_1"

set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHa /nologo /Fo"%OutPath%\\" %CFLAGS_PLAT% %MyCFLAGS%

rem ==== ==== ==== ====
echo ����%PLAT% lib��...

cl %CFLAGS% /Fd"%OutPath%\\lualib.pdb" /D "_LIB" *.c >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

del "%OutPath%\\lua.obj" "%OutPath%\\luac.obj"

lib /OUT:"%OutPath%\\lualib.lib" /LTCG /MACHINE:%PLAT% /NOLOGO "%OutPath%\\*.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

rem ==== ==== ==== ====

del "%OutPath%\\*.obj"

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

if "%1" == "" set LINKFLAGS_PLAT_CONSOLE= /SUBSYSTEM:CONSOLE
if not "%1" == "" set LINKFLAGS_PLAT_CONSOLE= /SAFESEH /SUBSYSTEM:CONSOLE",5.01" 

if "%1" == "" set LINKFLAGS_PLAT_WINDOWS= /SUBSYSTEM:WINDOWS
if not "%1" == "" set LINKFLAGS_PLAT_WINDOWS= /SAFESEH /SUBSYSTEM:WINDOWS",5.01" 

set LINKFLAGS= /MANIFEST:NO /LTCG /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /MACHINE:%PLAT% /OPT:REF /INCREMENTAL:NO /OPT:ICF /ERRORREPORT:NONE /NOLOGO

rem ==== ==== ==== ====
echo ����%PLAT% dll��...

cl %CFLAGS% /Fd"%OutPath%\\luadll.pdb" /D "_USRDLL" /D "_WINDLL" /D "LUA_BUILD_AS_DLL" *.c >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

del "%OutPath%\\lua.obj" "%OutPath%\\luac.obj"

link /OUT:"%OutPath%\\lua.dll" %LINKFLAGS% %LINKFLAGS_PLAT_WINDOWS% /IMPLIB:"%OutPath%\\lua.lib" /DLL "%OutPath%\\*.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

rem ==== ==== ==== ====
echo ����%PLAT% exe��...

cl %CFLAGS% /Fd"%OutPath%\\lua.pdb" lua.c >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

link /OUT:"%OutPath%\\lua.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lualib.lib" "%OutPath%\\lua.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

rem ==== ==== ==== ====
echo ����%PLAT% exec��...

cl %CFLAGS% /Fd"%OutPath%\\luac.pdb" luac.c >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

link /OUT:"%OutPath%\\luac.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lualib.lib" "%OutPath%\\luac.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

rem ==== ==== ==== ====
echo ����%PLAT% dll exe��...

link /OUT:"%OutPath%\\luadll.exe" %LINKFLAGS% %LINKFLAGS_PLAT_CONSOLE% "%OutPath%\\lua.lib" "%OutPath%\\lua.obj" >nul

if not %errorlevel%==0 echo !!!!!!!!����ʧ��!!!!!!!! && goto end

rem ==== ==== ==== ====

del "%OutPath%\\*.obj"

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo ���
:end

pause >nul