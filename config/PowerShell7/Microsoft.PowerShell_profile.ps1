oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\montys.omp.json | Invoke-Expression
cls
# 设置编码
$env:LANG = "en_US.UTF-8" 

function lss {
    & "D:\Program\Git\usr\bin\ls.exe" --color=auto $args
}

