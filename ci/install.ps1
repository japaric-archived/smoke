Set-PSDebug -Trace 1

if ($Env:TARGET -Match 'gnu') {
    $Env:HOST = 'x86_64-pc-windows-gnu'

    if ($Env:TARGET -Match 'x86_64') {
        $Env:PATH += ';C:\msys64\mingw64\bin'
    } else {
        $Env:PATH += ';C:\msys64\mingw32\bin'
    }
}

if ($Env:TARGET -Match 'msvc') {
    $Env:HOST = 'x86_64-pc-windows-msvc'
}

[Net.ServicePointManager]::SecurityProtocol = 'Ssl3, Tls, Tls12'
Start-FileDownload 'https://win.rustup.rs' 'rustup-init.exe'

.\rustup-init --default-host $Env:HOST --default-toolchain nightly -y

$Env:PATH = 'C:\Users\appveyor\.cargo\bin;' + $Env:PATH

if ($Env:TARGET -ne $Env:HOST) {
    rustup target add $Env:TARGET
}

$Env:PATH

rustc -Vv

cargo -V
