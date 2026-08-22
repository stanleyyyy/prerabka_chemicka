@echo off
setlocal

set FILES=rekonstrukcia_bytu.html elektroinstalacia.html kuchyna_vyvody.html
set BRANCH=main

cd /d "%~dp0"

rem Detects modified AND untracked files (git diff alone misses new files).
set CHANGES=
for /f "delims=" %%i in ('git status --porcelain -- %FILES%') do set CHANGES=1
if not defined CHANGES (
    echo No changes in %FILES%, nothing to push.
    goto :end
)

rem Switch branch before committing, otherwise the commit can land on
rem another branch while push sends an unchanged %BRANCH%.
git checkout %BRANCH% 2>nul || (
    echo Failed to switch to branch %BRANCH%.
    exit /b 1
)

git add %FILES%
git commit -m "Update %FILES%"
if %errorlevel% neq 0 (
    echo Commit failed.
    exit /b 1
)

git push origin %BRANCH%
if %errorlevel% neq 0 (
    echo Push failed.
    exit /b 1
)

echo Done. Changes pushed to origin/%BRANCH%.

:end
endlocal
