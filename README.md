# proto-tool 说明
    proto-tool是整理后使用protobuf工具集一键生成pb cpp cs java lua工具
    其中proto_tool目录下的工具是编译好的文件(编译方法详见工具编译部分)

----
## 工具的使用
1. 工具生成lua文件需要安装python2.7
2. 在protos目录下放置proto文件
3. 执行build_gen.bat会自动生成到out目录下

----
## 工具的编译
#### 编译protoc.exe工具
- 下载protobuf，新建down_protobuf.bat并执行
```bat
    ::参考文章 https://github.com/google/protobuf/blob/master/cmake/README.md
    ::默认当前操作系统已安装 git 和 cmake,并配置好了环境变量
    echo off & color 0A

    ::设置所需要的Protobuf版本,最新版本可以在github上查到 https://github.com/google/protobuf
    set PROTOBUF_VESION="3.0.0-beta-4"
    echo %PROTOBUF_VESION%
    set PROTOBUF_PATH="protobuf_%PROTOBUF_VESION%"
    echo %PROTOBUF_PATH%

    ::从githug上拉取protobuf源代码
    git clone -b %PROTOBUF_VESION% https://github.com/google/protobuf.git %PROTOBUF_PATH%

    ::从github上拉取gmock
    cd %PROTOBUF_PATH%
    git clone -b release-1.7.0 https://github.com/google/googlemock.git gmock

    ::从github上拉取gtest
    cd gmock
    git clone -b release-1.7.0 https://github.com/google/googletest.git gtest

    pause
```
- 编译protobuf，新建build_protobuf.bat并执行（需要安装cmake vs2015）
```bat
    ::参考文章 https://github.com/google/protobuf/blob/master/cmake/README.md
    ::默认当前操作系统已安装 git 和 cmake,并配置好了环境变量
    echo off & color 0A

    ::设置所需要的Protobuf版本,最新版本可以在github上查到 https://github.com/google/protobuf
    ::必须与下载的版本一致
    set PROTOBUF_VESION="3.0.0-beta-4"
    echo %PROTOBUF_VESION%
    set PROTOBUF_PATH="protobuf_%PROTOBUF_VESION%"
    echo %PROTOBUF_PATH%
    cd %PROTOBUF_PATH%

    ::设置VS工具集,相当于指定VS版本,取决于VS的安装路径
    set VS_DEV_CMD="C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
    ::设置工程文件夹名字,用来区分不同的VS版本
    set BUILD_PATH="build_VS2015"
    ::设置编译版本 Debug Or Release
    set MODE="Debug"

    cd cmake
    if not exist %BUILD_PATH% md %BUILD_PATH%

    cd %BUILD_PATH%
    if not exist %MODE% md %MODE%
    cd %MODE%

    ::开始构建和编译
    call %VS_DEV_CMD%
    cmake ../../ -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=%MODE%
    call extract_includes.bat
    nmake /f Makefile

    echo %cd%
    pause
```
- 拷贝cmake\build_VS2015\Release\protoc.exe 到proto_tool目录
#### 编译protogen工具
- 下载protobuf-net，新建down_protobuf.bat并执行
```bat
    ::默认当前操作系统已安装 git 和 cmake,并配置好了环境变量
    echo off & color 0A

    git clone https://github.com/mgravell/protobuf-net.git

    pause
```
- 在https://github.com/dotnet/cli 下载64位dotnet安装 并添加环境变量C:\Program Files\dotnet
- 编译protobuf-net 新建build_protobuf_net.bat并执行
```bat
    ::默认当前操作系统已安装 git 和 cmake,并配置好了环境变量
    echo off & color 0A

    ::编译依赖 从https://github.com/dotnet/cli下载安装dotnet sdk 添加环境变量C:\Program Files\dotnet 安装后记得关闭所有的explorer 
    cd protobuf-net\src
    dotnet restore
    dotnet build -c Release
    cd ..\..\

    echo %cd%
    pause
```
- 拷贝src\protogen\bin\Release\net40目录下所有的生成文件到proto_tool目录

#### 配置protogen-lua工具
- 安装python2.7 并配置环境变量
- 在proto_tool目录下执行以下命令下载protoc-gen-lua插件
    git clone https://github.com/sean-lin/protoc-gen-lua.git protoc-gen-lua
- 在protoc-gen-lua\plugin目录下新建批处理 protoc-gen-lua.bat 内容如下
    @python "%~dp0protoc-gen-lua"

#### 在proto_tool同级新建protos目录  里面放proto文件
### 新建编译proto 批处理build_gen.bat 执行后会自动编译生成到out路径下
```bat
    @echo off

    ::协议文件路径, 最后不要跟“\”符号
    set SOURCE_FOLDER=.\protos

    ::protoc编译器路径
    set PROTOC_COMPILER_PATH=.\proto_tool\protoc.exe
    ::protogen编译器路径
    set PROTOCGEN_COMPILER_PATH=.\proto_tool\protogen.exe
    ::protogenlua编译器路径
    set PROTOCGENLUA_COMPILER_PATH=.\proto_tool\protoc-gen-lua\plugin\protoc-gen-lua.bat

    ::pb文件生成路径, 最后不要跟“\”符号
    set PB_TARGET_PATH=.\out\pb
    ::Cpp文件生成路径, 最后不要跟“\”符号
    set CPP_TARGET_PATH=.\out\cpp 
    ::Java文件生成路径, 最后不要跟“\”符号
    set JAVA_TARGET_PATH=.\out\java 
    ::C#文件生成路径, 最后不要跟“\”符号
    set CS_TARGET_PATH=.\out\cs
    ::lua文件生成路径, 最后不要跟“\”符号
    set LUA_TARGET_PATH=.\out\lua

    ::删除之前创建的文件
    rd /s /q %PB_TARGET_PATH%
    rd /s /q %CPP_TARGET_PATH%
    rd /s /q %JAVA_TARGET_PATH%
    rd /s /q %CS_TARGET_PATH%
    rd /s /q %LUA_TARGET_PATH%
    md %PB_TARGET_PATH%
    md %CPP_TARGET_PATH%
    md %JAVA_TARGET_PATH%
    md %CS_TARGET_PATH%
    md %LUA_TARGET_PATH%


    ::遍历所有文件
    for /f "delims=" %%i in ('dir /b "%SOURCE_FOLDER%\*.proto"') do (

        ::生成 pb 二进制文件
        echo %PROTOC_COMPILER_PATH% -o %PB_TARGET_PATH%\%%~ni.pb %SOURCE_FOLDER%\%%i
        %PROTOC_COMPILER_PATH% -o %PB_TARGET_PATH%\%%~ni.pb %SOURCE_FOLDER%\%%i

        ::生成 CPP 代码
        echo %PROTOC_COMPILER_PATH% --cpp_out=%CPP_TARGET_PATH% %SOURCE_FOLDER%\%%i
        %PROTOC_COMPILER_PATH% --cpp_out=%CPP_TARGET_PATH% %SOURCE_FOLDER%\%%i
        
        ::生成 Java 代码
        echo %PROTOC_COMPILER_PATH% --java_out=%JAVA_TARGET_PATH% %SOURCE_FOLDER%\%%i
        %PROTOC_COMPILER_PATH% --java_out=%JAVA_TARGET_PATH% %SOURCE_FOLDER%\%%i
        
        ::生成 C# 代码
        echo %PROTOCGEN_COMPILER_PATH% --proto_path=%SOURCE_FOLDER% --csharp_out=%CS_TARGET_PATH%\  %%i
        %PROTOCGEN_COMPILER_PATH% --proto_path=%SOURCE_FOLDER% --csharp_out=%CS_TARGET_PATH%\  %%i
        
        ::生成 lua 代码
        echo %PROTOC_COMPILER_PATH% --lua_out=%LUA_TARGET_PATH% --plugin=protoc-gen-lua=%PROTOCGENLUA_COMPILER_PATH% %SOURCE_FOLDER%\%%i
        %PROTOC_COMPILER_PATH% --lua_out=%LUA_TARGET_PATH% --plugin=protoc-gen-lua=%PROTOCGENLUA_COMPILER_PATH% %SOURCE_FOLDER%\%%i
          
    )

    echo 协议生成完毕。

    pause
```
