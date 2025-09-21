@echo off
:: =============================================
:: Git �ֿ�ɨ���� v1.1 (��������ǿ��)
:: ���ܣ�ɨ��ָ��·���µ����� .git �ֿ�
:: �����·����Զ�̵�ַ������ύ
:: ע�⣺���� ANSI ���뱣����ļ���
:: =============================================

:: �����ӳٱ�����չ
setlocal enabledelayedexpansion

:: ���ô���ҳΪ�������ģ���ֹ���룩
chcp 936 >nul

echo.
echo ��ʼɨ�豾�� Git �ֿ�...
echo --------------------------------------------------
echo.

:: ����Ҫɨ��ĸ�Ŀ¼�����޸ģ�
set "ROOT_PATH=D:\"

:: ��ʱ�ļ������Ϣ
set "TEMP_FILE=%temp%\git_scan_temp.txt"
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

:: �������� .git �ļ���
for /f "delims=" %%d in ('dir /s /b /ad "%ROOT_PATH%.git" 2^>nul') do (
    echo ���ڴ���: %%d
    pushd "%%~dpd" && (
        :: ��ȡ��Ŀ��Ŀ¼��ȥ�� \.git��
        set "repo_path=%%~dpd"
        set "repo_path=!repo_path:~0,-1!"

        :: ��ȡԶ�̵�ַ
        for /f "delims=" %%r in ('git remote -v ^| findstr origin') do set "remote=%%r"
        if not defined remote set "remote=(��)"

        :: ��ȡ���һ���ύ
        for /f "delims=" %%c in ('git log --oneline -1 2^>nul') do set "commit=%%c"
        if not defined commit set "commit=(���ύ��ʷ)"

        >>"%TEMP_FILE%" echo ·��: !repo_path!
        >>"%TEMP_FILE%" echo   Զ��: !remote!
        >>"%TEMP_FILE%" echo   ����ύ: !commit!
        >>"%TEMP_FILE%" echo.

        set "remote="
        set "commit="
    )
    popd
)

:: ��ʾ���
if exist "%TEMP_FILE%" (
    type "%TEMP_FILE%"
) else (
    echo δ�� %ROOT_PATH% ���ҵ��κ� Git �ֿ⡣
)

:: ������ʱ�ļ������豣�����棬��ע�͵���һ�У�
del "%TEMP_FILE%" >nul 2>&1

echo --------------------------------------------------
echo ɨ����ɣ�
echo.
pause