@echo off
:: =============================================
:: Git 仓库扫描器 v1.1 (防乱码增强版)
:: 功能：扫描指定路径下的所有 .git 仓库
:: 输出：路径、远程地址、最近提交
:: 注意：请用 ANSI 编码保存此文件！
:: =============================================

:: 启用延迟变量扩展
setlocal enabledelayedexpansion

:: 设置代码页为简体中文（防止乱码）
chcp 936 >nul

echo.
echo 开始扫描本地 Git 仓库...
echo --------------------------------------------------
echo.

:: 设置要扫描的根目录（可修改）
set "ROOT_PATH=D:\"

:: 临时文件存放信息
set "TEMP_FILE=%temp%\git_scan_temp.txt"
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

:: 查找所有 .git 文件夹
for /f "delims=" %%d in ('dir /s /b /ad "%ROOT_PATH%.git" 2^>nul') do (
    echo 正在处理: %%d
    pushd "%%~dpd" && (
        :: 获取项目根目录（去掉 \.git）
        set "repo_path=%%~dpd"
        set "repo_path=!repo_path:~0,-1!"

        :: 获取远程地址
        for /f "delims=" %%r in ('git remote -v ^| findstr origin') do set "remote=%%r"
        if not defined remote set "remote=(无)"

        :: 获取最近一次提交
        for /f "delims=" %%c in ('git log --oneline -1 2^>nul') do set "commit=%%c"
        if not defined commit set "commit=(无提交历史)"

        >>"%TEMP_FILE%" echo 路径: !repo_path!
        >>"%TEMP_FILE%" echo   远程: !remote!
        >>"%TEMP_FILE%" echo   最近提交: !commit!
        >>"%TEMP_FILE%" echo.

        set "remote="
        set "commit="
    )
    popd
)

:: 显示结果
if exist "%TEMP_FILE%" (
    type "%TEMP_FILE%"
) else (
    echo 未在 %ROOT_PATH% 下找到任何 Git 仓库。
)

:: 清理临时文件（如需保留报告，请注释掉下一行）
del "%TEMP_FILE%" >nul 2>&1

echo --------------------------------------------------
echo 扫描完成！
echo.
pause