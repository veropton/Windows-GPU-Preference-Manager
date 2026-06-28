# ============================================================
#  SmartGraphicsPreference.ps1 v2.0
#  Gerenciador Inteligente de Preferencia Grafica
#  - Filtra ruido de sistema automaticamente
#  - Base de conhecimento de apps GPU-intensivos
#  - Monitor de uso real de GPU por processo
#  - Recomendacoes automaticas destacadas
#  - Busca, filtro e aplicacao em lote
# ============================================================

# --- BASE DE CONHECIMENTO ---
$appsDB = @{
    # Navegadores
    "chrome"             = @{ Cat = "Navegador";   Rec = $true  }
    "firefox"            = @{ Cat = "Navegador";   Rec = $true  }
    "librewolf"          = @{ Cat = "Navegador";   Rec = $true  }
    "msedge"             = @{ Cat = "Navegador";   Rec = $true  }
    "opera"              = @{ Cat = "Navegador";   Rec = $true  }
    "brave"              = @{ Cat = "Navegador";   Rec = $true  }
    "vivaldi"            = @{ Cat = "Navegador";   Rec = $true  }
    "thorium"            = @{ Cat = "Navegador";   Rec = $true  }
    "waterfox"           = @{ Cat = "Navegador";   Rec = $true  }
    # Video
    "vlc"                = @{ Cat = "Video";       Rec = $true  }
    "mpc-hc64"           = @{ Cat = "Video";       Rec = $true  }
    "mpc-hc"             = @{ Cat = "Video";       Rec = $true  }
    "mpv"                = @{ Cat = "Video";       Rec = $true  }
    "wmplayer"           = @{ Cat = "Video";       Rec = $true  }
    "plex"               = @{ Cat = "Video";       Rec = $true  }
    # Design / 3D
    "blender"            = @{ Cat = "3D";          Rec = $true  }
    "photoshop"          = @{ Cat = "Design";      Rec = $true  }
    "illustrator"        = @{ Cat = "Design";      Rec = $true  }
    "krita"              = @{ Cat = "Design";      Rec = $true  }
    "gimp-2.10"          = @{ Cat = "Design";      Rec = $true  }
    "gimp"               = @{ Cat = "Design";      Rec = $true  }
    "inkscape"           = @{ Cat = "Design";      Rec = $true  }
    "figma"              = @{ Cat = "Design";      Rec = $true  }
    # Edicao de Video
    "premiere"           = @{ Cat = "Edicao";      Rec = $true  }
    "afterfx"            = @{ Cat = "Edicao";      Rec = $true  }
    "resolve"            = @{ Cat = "Edicao";      Rec = $true  }
    "fusion"             = @{ Cat = "Edicao";      Rec = $true  }
    "vegas130"           = @{ Cat = "Edicao";      Rec = $true  }
    "kdenlive"           = @{ Cat = "Edicao";      Rec = $true  }
    "handbrake"          = @{ Cat = "Edicao";      Rec = $true  }
    # Streaming
    "obs64"              = @{ Cat = "Streaming";   Rec = $true  }
    "obs32"              = @{ Cat = "Streaming";   Rec = $true  }
    "streamlabsobs"      = @{ Cat = "Streaming";   Rec = $true  }
    # Games / Launchers
    "steam"              = @{ Cat = "Games";       Rec = $true  }
    "epicgameslauncher"  = @{ Cat = "Games";       Rec = $true  }
    "leagueclient"       = @{ Cat = "Games";       Rec = $true  }
    "riotclient"         = @{ Cat = "Games";       Rec = $true  }
    "battlenet"          = @{ Cat = "Games";       Rec = $true  }
    "goggalaxy"          = @{ Cat = "Games";       Rec = $true  }
    "gameoverlayui"      = @{ Cat = "Games";       Rec = $true  }
    # Comunicacao com GPU
    "discord"            = @{ Cat = "Comunicacao"; Rec = $true  }
    "zoom"               = @{ Cat = "Comunicacao"; Rec = $true  }
    "teams"              = @{ Cat = "Comunicacao"; Rec = $false }
    "slack"              = @{ Cat = "Comunicacao"; Rec = $false }
    # Dev (normalmente nao precisa)
    "code"               = @{ Cat = "Dev";         Rec = $false }
    "devenv"             = @{ Cat = "Dev";         Rec = $false }
    "rider64"            = @{ Cat = "Dev";         Rec = $false }
    "webstorm64"         = @{ Cat = "Dev";         Rec = $false }
    "pycharm64"          = @{ Cat = "Dev";         Rec = $false }
}

# Processos de sistema que nao aparecem na lista
$sistemaNomes = [System.Collections.Generic.HashSet[string]]::new(
    [string[]]@(
        "svchost","csrss","winlogon","wininit","services","lsass","spoolsv",
        "taskhost","taskhostw","dwm","conhost","sihost","fontdrvhost",
        "searchhost","startmenuexperiencehost","shellexperiencehost",
        "runtimebroker","applicationframehost","systemsettings","wmiprvse",
        "audiodg","ctfmon","dllhost","explorer","powershell","pwsh","cmd",
        "msmpeng","nissrv","securityhealthsystray","registry","smss",
        "searchindexer","textinputhost","lockapp","logonui","userinit",
        "msedgewebview2","smartgraphicsprefs","sgp","sgpref",
        "addgraphicspreference","idle","system"
    ),
    [System.StringComparer]::OrdinalIgnoreCase
)

$chaveReg   = "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
$ALTO       = 2

if (-not (Test-Path $chaveReg)) { New-Item -Path $chaveReg -Force | Out-Null }

# ---- FUNCOES ----

function Get-GpuStatus($path) {
    try {
        $v = (Get-ItemProperty -Path $chaveReg -Name $path -ErrorAction Stop).$path
        if ($v -match "GpuPreference=2") { return "alto" }
        if ($v -match "GpuPreference=1") { return "economia" }
        if ($v -match "GpuPreference=0") { return "padrao" }
    } catch {}
    return "nenhum"
}

function Get-GpuUsage() {
    $uso = @{}
    try {
        $counters = Get-Counter "\GPU Engine(*engtype_3D*)\Utilization Percentage" `
            -SampleInterval 1 -MaxSamples 1 -ErrorAction Stop
        foreach ($s in $counters.CounterSamples) {
            if ($s.CookedValue -gt 0 -and $s.InstanceName -match "pid_(\d+)") {
                $pid = [int]$Matches[1]
                $pct = [math]::Round($s.CookedValue, 0)
                if (-not $uso.ContainsKey($pid) -or $uso[$pid] -lt $pct) {
                    $uso[$pid] = $pct
                }
            }
        }
    } catch {}
    return $uso
}

function Get-Processos($filtro = "") {
    $lista = Get-Process |
        Where-Object { $_.Path -and -not $sistemaNomes.Contains($_.Name) } |
        Group-Object Path |
        ForEach-Object { $_.Group | Sort-Object Id | Select-Object -First 1 } |
        Sort-Object Name
    if ($filtro) { $lista = $lista | Where-Object { $_.Name -like "*$filtro*" } }
    return $lista
}

function Set-Alto($path, $nome) {
    Set-ItemProperty -Path $chaveReg -Name $path -Value "GpuPreference=$ALTO;" -Force
    Write-Host "  [+] $nome --> Alto Desempenho" -ForegroundColor Green
}

function Remove-Alto($path, $nome) {
    Remove-ItemProperty -Path $chaveReg -Name $path -ErrorAction SilentlyContinue
    Write-Host "  [-] $nome --> Removido (padrao do sistema)" -ForegroundColor DarkYellow
}

# ---- LOOP PRINCIPAL ----

$filtroAtual = ""

while ($true) {
    Clear-Host

    Write-Host ""
    Write-Host "  =====================================================" -ForegroundColor Cyan
    Write-Host "    Preferencia Grafica Inteligente   [Alto Desempenho]" -ForegroundColor Cyan
    Write-Host "  =====================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Lendo GPU..." -NoNewline -ForegroundColor DarkGray
    $gpuUso = Get-GpuUsage
    Write-Host "`r               `r" -NoNewline

    $processos = Get-Processos $filtroAtual
    $mapa = @{}

    if ($processos.Count -eq 0) {
        Write-Host "  Nenhum app encontrado$(if ($filtroAtual) { " para '$filtroAtual'" })." -ForegroundColor Yellow
    } else {
        Write-Host ("  {0,-4} {1,-26} {2,-12} {3,-6} {4}" -f "#", "App", "Categoria", "GPU%", "Status") -ForegroundColor DarkGray
        Write-Host ("  " + [string]::new('-', 64)) -ForegroundColor DarkGray

        $i = 1
        foreach ($p in $processos) {
            $db     = $appsDB[$p.Name.ToLower()]
            $cat    = if ($db) { $db.Cat } else { "Outro" }
            $rec    = if ($db) { $db.Rec } else { $false }
            $status = Get-GpuStatus $p.Path
            $gpuPct = if ($gpuUso.ContainsKey($p.Id)) { "$($gpuUso[$p.Id])%" } else { "" }

            # Prioridade de cor: verde = configurado, amarelo = recomendado, cinza = outro
            if ($status -eq "alto") {
                $cor = "Green";  $tag = "[OK] Alto Desempenho"
            } elseif ($rec) {
                $cor = "Yellow"; $tag = "[RECOMENDADO]"
            } elseif ($cat -eq "Outro") {
                $cor = "DarkGray"; $tag = ""
            } else {
                $cor = "White";  $tag = ""
            }

            Write-Host ("  {0,-4} {1,-26} {2,-12} {3,-6} {4}" -f $i, $p.Name, $cat, $gpuPct, $tag) -ForegroundColor $cor
            $mapa[$i] = @{ Proc = $p; Rec = $rec; Status = $status; Cat = $cat }
            $i++
        }
    }

    # Legenda
    $totalRec = ($mapa.Values | Where-Object { $_.Rec -and $_.Status -ne "alto" }).Count
    $totalOk  = ($mapa.Values | Where-Object { $_.Status -eq "alto" }).Count
    Write-Host ""
    Write-Host ("  " + [string]::new('-', 64)) -ForegroundColor DarkGray
    Write-Host "  Comandos:" -ForegroundColor DarkGray
    Write-Host "    1 / 1,3,5    Ativar ou remover (toggle)"        -ForegroundColor DarkGray
    Write-Host "    rec          Aplicar TODOS os recomendados ($totalRec pendentes)" -ForegroundColor DarkGray
    Write-Host "    busca <x>    Filtrar lista (ex: busca discord)" -ForegroundColor DarkGray
    Write-Host "    todos        Limpar filtro"                      -ForegroundColor DarkGray
    Write-Host "    sair         Fechar"                             -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Resumo: $totalOk configurado(s), $totalRec recomendado(s) pendente(s)" -ForegroundColor DarkCyan
    if ($filtroAtual) { Write-Host "  Filtro: '$filtroAtual'" -ForegroundColor Cyan }
    Write-Host ""

    $entrada = (Read-Host "  >").Trim().ToLower()

    if ($entrada -eq "sair") { break }

    if ($entrada -eq "todos") { $filtroAtual = ""; continue }

    if ($entrada -match "^busca (.+)") { $filtroAtual = $Matches[1].Trim(); continue }

    if ($entrada -eq "rec") {
        $feitos = 0
        foreach ($k in $mapa.Keys) {
            $item = $mapa[$k]
            if ($item.Rec -and $item.Status -ne "alto") {
                Set-Alto $item.Proc.Path $item.Proc.Name
                $feitos++
            }
        }
        if ($feitos -eq 0) { Write-Host "  Todos os recomendados ja estao configurados!" -ForegroundColor Green }
        else { Write-Host "  $feitos app(s) configurados com sucesso!" -ForegroundColor Cyan }
        Read-Host "  [Enter para continuar]"
        continue
    }

    # Numeros (toggle)
    $nums = $entrada -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" }
    if ($nums.Count -gt 0) {
        foreach ($n in $nums) {
            $idx = [int]$n
            if ($mapa.ContainsKey($idx)) {
                $item = $mapa[$idx]
                if ($item.Status -eq "alto") { Remove-Alto $item.Proc.Path $item.Proc.Name }
                else                         { Set-Alto   $item.Proc.Path $item.Proc.Name }
            } else {
                Write-Host "  [!] Numero $idx nao encontrado." -ForegroundColor Red
            }
        }
        Read-Host "  [Enter para continuar]"
    }
}

Write-Host ""
Write-Host "  Pronto! Reinicie os apps alterados para aplicar as mudancas." -ForegroundColor Magenta
Write-Host ""
