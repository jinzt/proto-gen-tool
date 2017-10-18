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
