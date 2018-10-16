# Lua

Lua 虽然提供了原生的 Makefile，但要在 windows 下编译，需要额外安装 MingW 。

nmake 不支持 VPATH ，前缀路径无法触发默认编译，无特殊宏 `&@` 等。

本工程是一个特化编译 For Windows 。

---- ---- ---- ----

## 特化编译

参考 Lua 提供的 windows 下的编译手段，实现特化 Makefile 。

`Makefile` 使用 GNU make 编译 Lua 。

`Makefile.bat` 检测当前环境，决定编译结果：

  - 在 对应的编译环境 下，编译对应平台版本，有编译回显。
  - 无编译环境时，自行编译 x64 & x86 版本，无编译回显。