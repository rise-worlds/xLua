# 检查 ANDROID_NDK 环境变量
if ($env:ANDROID_NDK) {
    $NDK = $env:ANDROID_NDK
} elseif ($env:ANDROID_NDK_HOME) {
    $NDK = $env:ANDROID_NDK_HOME
} else {
    $NDK = "$HOME/android-ndk-r15c"
}

# 检查 NDK 路径是否存在
if (-not (Test-Path -Path $NDK)) {
    Write-Host "Please set ANDROID_NDK environment to the root of NDK."
    exit 1
}

# 定义构建函数
function Build {
    param (
        [string]$API,
        [string]$ABI,
        [string]$TARGET
    )
    
    $TOOLCHAIN="$env:ANDROID_NDK\toolchains\llvm\prebuilt\windows-x86_64"
    $env:Path = "$TOOLCHAIN\bin;C:/Users/zhang/scoop/shims/Ninja.exe;$env:Path"
    
    $CC="$TOOLCHAIN\bin\$TARGET$API-clang"
    $CXX="$TOOLCHAIN\bin\$TARGET$API-clang++"
    $AR="$TOOLCHAIN\bin\llvm-ar"
    $AS=$CC
    $LD="$TOOLCHAIN\bin\ld"
    $RANLIB="$TOOLCHAIN\bin\llvm-ranlib"
    $STRIP="$TOOLCHAIN\bin\llvm-strip"
    
    $BUILD_PATH="build.Android.$ABI"
    if (Test-Path -Path $BUILD_PATH) {
        Remove-Item -Recurse -Force $BUILD_PATH
    }

    cmake -DCMAKE_TOOLCHAIN_FILE="$env:ANDROID_NDK\build\cmake\android.toolchain.cmake" -DCMAKE_ANDROID_NDK=$env:ANDROID_NDK -DANDROID_NATIVE_API_LEVEL=$API -DANDROID_ABI="$ABI" -DCMAKE_BUILD_TYPE=Release -DANDROID_TOOLCHAIN=clang -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" -DANDROID_STL=c++_static -DANDROID_PLATFORM="android-$API" -G Ninja -S . -B"$BUILD_PATH" -DANDROID=1
    cmake --build "$BUILD_PATH" --config Release

    $OutputDir = "plugin_lua53/Plugins/Android/libs/$ABI/"
    if (-not (Test-Path -Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }

    Copy-Item -Path "$BUILD_PATH/libxlua.so" -Destination "$OutputDir/libxlua.so" -Force
}

# 调用构建函数
Build -API 16 -ABI "armeabi-v7a" -TARGET "armv7a-linux-androideabi"
Build -API 16 -ABI "arm64-v8a" -TARGET "aarch64-linux-android"
Build -API 16 -ABI "x86" -TARGET "i686-linux-android"

# $API=16
# $ABI="armeabi-v7a"
# $TARGET="armv7a-linux-androideabi"

# $CC="$TOOLCHAIN\bin\$TARGET$API-clang"
# $CXX="$TOOLCHAIN\bin\$TARGET$API-clang++"
# $AR="$TOOLCHAIN\bin\llvm-ar"
# $AS=$CC
# $LD="$TOOLCHAIN\bin\ld"
# $RANLIB="$TOOLCHAIN\bin\llvm-ranlib"
# $STRIP="$TOOLCHAIN\bin\llvm-strip"

# $BUILD_PATH="build.Android.$ABI"

# cmake -DCMAKE_TOOLCHAIN_FILE="$env:ANDROID_NDK\build\cmake\android.toolchain.cmake" -DCMAKE_ANDROID_NDK=$env:ANDROID_NDK -DANDROID_NATIVE_API_LEVEL=$API -DANDROID_ABI="armeabi-v7a" -DCMAKE_BUILD_TYPE=Release -DANDROID_TOOLCHAIN=clang -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" -DANDROID_STL=c++_static -DANDROID_PLATFORM="android-$API" -G Ninja -S . -B"$BUILD_PATH" -DANDROID=1

# cmake --build "$BUILD_PATH" --config Release

# $API=21
# $ABI="arm64-v8a"
# $TARGET="aarch64-linux-android"

# $CC="$TOOLCHAIN\bin\$TARGET$API-clang"
# $CXX="$TOOLCHAIN\bin\$TARGET$API-clang++"
# $AR="$TOOLCHAIN\bin\llvm-ar"
# $AS=$CC
# $LD="$TOOLCHAIN\bin\ld"
# $RANLIB="$TOOLCHAIN\bin\llvm-ranlib"
# $STRIP="$TOOLCHAIN\bin\llvm-strip"

# $BUILD_PATH="build.Android.$ABI"

# cmake -DCMAKE_TOOLCHAIN_FILE="$env:ANDROID_NDK\build\cmake\android.toolchain.cmake" -DCMAKE_ANDROID_NDK=$env:ANDROID_NDK -DANDROID_NATIVE_API_LEVEL=$API -DANDROID_ABI="arm64-v8a" -DCMAKE_BUILD_TYPE=Release -DANDROID_TOOLCHAIN=clang -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" -DANDROID_STL=c++_static -DANDROID_PLATFORM="android-$API" -G Ninja -S . -B"$BUILD_PATH" -DANDROID=1

# cmake --build "$BUILD_PATH" --config Release

# $API=16
# $ABI="x86"
# $TARGET="i686-linux-android"

# $CC="$TOOLCHAIN\bin\$TARGET$API-clang"
# $CXX="$TOOLCHAIN\bin\$TARGET$API-clang++"
# $AR="$TOOLCHAIN\bin\llvm-ar"
# $AS=$CC
# $LD="$TOOLCHAIN\bin\ld"
# $RANLIB="$TOOLCHAIN\bin\llvm-ranlib"
# $STRIP="$TOOLCHAIN\bin\llvm-strip"

# $BUILD_PATH="build.Android.$ABI"

# cmake -DCMAKE_TOOLCHAIN_FILE="$env:ANDROID_NDK\build\cmake\android.toolchain.cmake" -DCMAKE_ANDROID_NDK=$env:ANDROID_NDK -DANDROID_NATIVE_API_LEVEL=$API -DANDROID_ABI="x86" -DCMAKE_BUILD_TYPE=Release -DANDROID_TOOLCHAIN=clang -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" -DANDROID_STL=c++_static -DANDROID_PLATFORM="android-$API" -G Ninja -S . -B"$BUILD_PATH" -DANDROID=1

# cmake --build "$BUILD_PATH" --config Release




