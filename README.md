# Lua

这里提供的[Makefile.bat](./Makefile.bat)，用于使用VS2017命令行编译Lua

如需要使用其它VS编译其它版本，请修改如下参考：

    set VCPath=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\lua-5.3.4\src

虽然使用Makefile看起来高大上，但这里不采用，原因如下：
- nmake不支持VPATH，前缀路径无法触发默认编译，无特殊宏“&@”等
- gmake、dmake对GPATH支持不好，非当前目录的生成结果无法判定，必须写明，且obj没有默认规则
- 生成结果需要一次性生成x64、x86。用gmake与dmake明显浪费。用nmake又需要开环境显得麻烦
- Lua虽然提供了原生的makefile，但要在windows下编译，需要额外安排MingW