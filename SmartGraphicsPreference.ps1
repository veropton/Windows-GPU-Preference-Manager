param(
    [Parameter(Mandatory=$false)]
    [string]$Language
)

# Set UTF-8 output encoding for the console to support Chinese, Japanese, and accented characters
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {}


# ============================================================
#  SmartGraphicsPreference.ps1 v2.0
#  Interactive Windows GPU Preference Manager
#  - Filters common system-process noise automatically
#  - Uses a small knowledge base for GPU-intensive apps
#  - Shows live GPU usage per process when available
#  - Highlights recommended apps
#  - Supports search, filtering, and batch application
#  - Supports multilingual localization (EN, PT, ES, FR, DE, ZH, JA, IT)
# ============================================================

# --- LOCALIZATION STRINGS ---
$translations = @{
    "en" = @{
        Title            = "Windows GPU Preference Manager"
        HighPerf         = "High Performance"
        ReadingUsage     = "Reading GPU usage..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Category"
        ColGpu           = "GPU%"
        ColStatus        = "Status"
        StatusHigh       = "[OK] High Performance"
        StatusRec        = "[RECOMMENDED]"
        CatBrowser       = "Browser"
        CatVideo         = "Video"
        Cat3D            = "3D"
        CatDesign        = "Design"
        CatVideoEdit     = "Video Edit"
        CatStreaming     = "Streaming"
        CatGames         = "Games"
        CatCommunication = "Communication"
        CatDeveloper     = "Developer"
        CatOther         = "Other"
        NoAppsFound      = "No apps found{0}."
        ForFilter        = " for '{0}'"
        CommandsHeader   = "Commands:"
        CmdToggle        = "Toggle high-performance preference"
        CmdRecApply      = "Apply all recommended apps ({0} pending)"
        CmdSearch        = "Filter list"
        CmdAll           = "Clear filter"
        CmdQuit          = "Close"
        SummaryInfo      = "Summary: {0} configured, {1} recommended pending"
        FilterInfo       = "Filter: '{0}'"
        AllConfigured    = "All recommended apps are already configured."
        AppsConfigured   = "{0} app(s) configured successfully."
        PressEnter       = "[Press Enter to continue]"
        NumNotFound      = "[!] Number {0} was not found."
        DoneMessage      = "Done. Restart changed apps so Windows can apply the new preference."
        SuccessAdd       = "  [+] {0} --> High Performance"
        SuccessRemove    = "  [-] {0} --> Removed (Windows default)"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
        }
    }
    "pt" = @{
        Title            = "Gerenciador de Preferência de GPU do Windows"
        HighPerf         = "Alto Desempenho"
        ReadingUsage     = "Lendo uso de GPU..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Categoria"
        ColGpu           = "GPU%"
        ColStatus        = "Status"
        StatusHigh       = "[OK] Alto Desempenho"
        StatusRec        = "[RECOMENDADO]"
        CatBrowser       = "Navegador"
        CatVideo         = "Vídeo"
        Cat3D            = "3D"
        CatDesign        = "Design"
        CatVideoEdit     = "Edição de Vídeo"
        CatStreaming     = "Streaming"
        CatGames         = "Jogos"
        CatCommunication = "Comunicação"
        CatDeveloper     = "Desenvolvedor"
        CatOther         = "Outro"
        NoAppsFound      = "Nenhum app encontrado{0}."
        ForFilter        = " para '{0}'"
        CommandsHeader   = "Comandos:"
        CmdToggle        = "Alternar preferência de alto desempenho"
        CmdRecApply      = "Aplicar todos os recomendados ({0} pendentes)"
        CmdSearch        = "Filtrar lista"
        CmdAll           = "Limpar filtro"
        CmdQuit          = "Fechar"
        SummaryInfo      = "Resumo: {0} configurado(s), {1} recomendado(s) pendente(s)"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Todos os apps recomendados já estão configurados."
        AppsConfigured   = "{0} app(s) configurado(s) com sucesso."
        PressEnter       = "[Pressione Enter para continuar]"
        NumNotFound      = "[!] Número {0} não foi encontrado."
        DoneMessage      = "Concluído. Reinicie os apps alterados para que o Windows aplique a nova preferência."
        SuccessAdd       = "  [+] {0} --> Alto Desempenho"
        SuccessRemove    = "  [-] {0} --> Removido (Padrão do Windows)"
        CommandKeywords  = @{
            Quit   = "sair"
            All    = "todos"
            Search = "busca"
            Rec    = "rec"
            Apply  = "aplicar"
        }
    }
    "es" = @{
        Title            = "Administrador de Preferencias de GPU de Windows"
        HighPerf         = "Alto Rendimiento"
        ReadingUsage     = "Leyendo uso de GPU..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Categoría"
        ColGpu           = "GPU%"
        ColStatus        = "Estado"
        StatusHigh       = "[OK] Alto Rendimiento"
        StatusRec        = "[RECOMENDADO]"
        CatBrowser       = "Navegador"
        CatVideo         = "Vídeo"
        Cat3D            = "3D"
        CatDesign        = "Diseño"
        CatVideoEdit     = "Edición de Vídeo"
        CatStreaming     = "Streaming"
        CatGames         = "Juegos"
        CatCommunication = "Comunicación"
        CatDeveloper     = "Desarrollador"
        CatOther         = "Otro"
        NoAppsFound      = "No se encontraron aplicaciones{0}."
        ForFilter        = " para '{0}'"
        CommandsHeader   = "Comandos:"
        CmdToggle        = "Alternar preferencia de alto rendimiento"
        CmdRecApply      = "Aplicar todos los recomendados ({0} pendientes)"
        CmdSearch        = "Filtrar lista"
        CmdAll           = "Limpar filtro"
        CmdQuit          = "Salir"
        SummaryInfo      = "Resumen: {0} configurado(s), {1} recomendado(s) pendiente(s)"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Todas las aplicaciones recomendadas ya están configuradas."
        AppsConfigured   = "{0} aplicación(es) configurada(s) con éxito."
        PressEnter       = "[Presione Enter para continuar]"
        NumNotFound      = "[!] El número {0} no fue encontrado."
        DoneMessage      = "Hecho. Reinicie las aplicaciones cambiadas para que Windows aplique la nueva preferencia."
        SuccessAdd       = "  [+] {0} --> Alto Rendimiento"
        SuccessRemove    = "  [-] {0} --> Eliminado (Predeterminado de Windows)"
        CommandKeywords  = @{
            Quit   = "salir"
            All    = "todos"
            Search = "buscar"
            Rec    = "rec"
            Apply  = "aplicar"
        }
    }
    "fr" = @{
        Title            = "Gestionnaire de Préférences GPU Windows"
        HighPerf         = "Performances Élevées"
        ReadingUsage     = "Lecture de l'utilisation du GPU..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Catégorie"
        ColGpu           = "GPU%"
        ColStatus        = "Statut"
        StatusHigh       = "[OK] Performances Élevées"
        StatusRec        = "[RECOMMANDÉ]"
        CatBrowser       = "Navigateur"
        CatVideo         = "Vidéo"
        Cat3D            = "3D"
        CatDesign        = "Design"
        CatVideoEdit     = "Montage Vidéo"
        CatStreaming     = "Streaming"
        CatGames         = "Jeux"
        CatCommunication = "Communication"
        CatDeveloper     = "Développeur"
        CatOther         = "Autre"
        NoAppsFound      = "Aucune application trouvée{0}."
        ForFilter        = " pour '{0}'"
        CommandsHeader   = "Commandes :"
        CmdToggle        = "Basculer la préférence de performances élevées"
        CmdRecApply      = "Appliquer toutes les applications recommandées ({0} en attente)"
        CmdSearch        = "Filtrer la liste"
        CmdAll           = "Effacer le filtre"
        CmdQuit          = "Quitter"
        SummaryInfo      = "Résumé : {0} configurée(s), {1} recommandée(s) en attente"
        FilterInfo       = "Filtre : '{0}'"
        AllConfigured    = "Toutes les applications recommandées sont déjà configurées."
        AppsConfigured   = "{0} application(s) configurée(s) avec succès."
        PressEnter       = "[Appuyez sur Entrée pour continuer]"
        NumNotFound      = "[!] Le numéro {0} n'a pas été trouvé."
        DoneMessage      = "Terminé. Redémarrez les applications modifiées pour que Windows applique la nouvelle préférence."
        SuccessAdd       = "  [+] {0} --> Performances Élevées"
        SuccessRemove    = "  [-] {0} --> Supprimé (Par défaut de Windows)"
        CommandKeywords  = @{
            Quit   = "quitter"
            All    = "tout"
            Search = "recherche"
            Rec    = "rec"
            Apply  = "appliquer"
        }
    }
    "de" = @{
        Title            = "Windows GPU-Präferenz-Manager"
        HighPerf         = "Hohe Leistung"
        ReadingUsage     = "GPU-Auslastung wird gelesen..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Kategorie"
        ColGpu           = "GPU%"
        ColStatus        = "Status"
        StatusHigh       = "[OK] Hohe Leistung"
        StatusRec        = "[EMPFOHLEN]"
        CatBrowser       = "Browser"
        CatVideo         = "Video"
        Cat3D            = "3D"
        CatDesign        = "Design"
        CatVideoEdit     = "Videobearbeitung"
        CatStreaming     = "Streaming"
        CatGames         = "Spiele"
        CatCommunication = "Kommunikation"
        CatDeveloper     = "Entwickler"
        CatOther         = "Andere"
        NoAppsFound      = "Keine Apps gefunden{0}."
        ForFilter        = " für '{0}'"
        CommandsHeader   = "Befehle:"
        CmdToggle        = "Hohe Leistungspräferenz umschalten"
        CmdRecApply      = "Alle empfohlenen Apps anwenden ({0} ausstehend)"
        CmdSearch        = "Liste filtern"
        CmdAll           = "Filter löschen"
        CmdQuit          = "Beenden"
        SummaryInfo      = "Zusammenfassung: {0} konfiguriert, {1} empfohlen ausstehend"
        FilterInfo       = "Filter: '{0}'"
        AllConfigured    = "Alle empfohlenen Apps sind bereits konfiguriert."
        AppsConfigured   = "{0} App(s) erfolgreich konfiguriert."
        PressEnter       = "[Eingabetaste drücken, um fortzufahren]"
        NumNotFound      = "[!] Nummer {0} wurde nicht gefunden."
        DoneMessage      = "Fertig. Starten Sie geänderte Apps neu, damit Windows die neue Präferenz übernehmen kann."
        SuccessAdd       = "  [+] {0} --> Hohe Leistung"
        SuccessRemove    = "  [-] {0} --> Entfernt (Windows-Standard)"
        CommandKeywords  = @{
            Quit   = "beenden"
            All    = "alle"
            Search = "suche"
            Rec    = "rec"
            Apply  = "anwenden"
        }
    }
    "zh" = @{
        Title            = "Windows GPU 首选项管理器"
        HighPerf         = "高性能"
        ReadingUsage     = "正在读取 GPU 使用率..."
        ColNum           = "#"
        ColApp           = "应用"
        ColCategory      = "类别"
        ColGpu           = "GPU%"
        ColStatus        = "状态"
        StatusHigh       = "[OK] 高性能"
        StatusRec        = "[推荐]"
        CatBrowser       = "浏览器"
        CatVideo         = "视频"
        Cat3D            = "3D"
        CatDesign        = "设计"
        CatVideoEdit     = "视频编辑"
        CatStreaming     = "串流"
        CatGames         = "游戏"
        CatCommunication = "通讯"
        CatDeveloper     = "开发者"
        CatOther         = "其他"
        NoAppsFound      = "未找到应用{0}。"
        ForFilter        = " 针对 '{0}'"
        CommandsHeader   = "命令:"
        CmdToggle        = "切换高性能首选项"
        CmdRecApply      = "应用所有推荐的应用（{0} 个待处理）"
        CmdSearch        = "过滤列表"
        CmdAll           = "清除过滤器"
        CmdQuit          = "关闭"
        SummaryInfo      = "摘要: {0} 已配置, {1} 个推荐待处理"
        FilterInfo       = "过滤器: '{0}'"
        AllConfigured    = "所有推荐的应用都已配置。"
        AppsConfigured   = "{0} 个应用配置成功。"
        PressEnter       = "[按回车键继续]"
        NumNotFound      = "[!] 未找到数字 {0}。"
        DoneMessage      = "完成。请重启更改的应用，以便 Windows 应用新的首选项。"
        SuccessAdd       = "  [+] {0} --> 高性能"
        SuccessRemove    = "  [-] {0} --> 已移除 (Windows 默认)"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
        }
    }
    "ja" = @{
        Title            = "Windows GPU グラフィックス仕様マネージャー"
        HighPerf         = "高パフォーマンス"
        ReadingUsage     = "GPU 使用状況を読み込み中..."
        ColNum           = "#"
        ColApp           = "アプリ"
        ColCategory      = "カテゴリ"
        ColGpu           = "GPU%"
        ColStatus        = "ステータス"
        StatusHigh       = "[OK] 高パフォーマンス"
        StatusRec        = "[推奨]"
        CatBrowser       = "ブラウザ"
        CatVideo         = "ビデオ"
        Cat3D            = "3D"
        CatDesign        = "デザイン"
        CatVideoEdit     = "動画編集"
        CatStreaming     = "ストリーミング"
        CatGames         = "ゲーム"
        CatCommunication = "コミュニケーション"
        CatDeveloper     = "開発者"
        CatOther         = "その他"
        NoAppsFound      = "アプリが見つかりません{0}。"
        ForFilter        = " 検索: '{0}'"
        CommandsHeader   = "コマンド:"
        CmdToggle        = "高パフォーマンス設定 of 切り替え"
        CmdRecApply      = "すべての推奨アプリを適用 ({0} 件保留中)"
        CmdSearch        = "リストを絞り込む"
        CmdAll           = "フィルターをクリア"
        CmdQuit          = "終了"
        SummaryInfo      = "概要: {0} 件設定済み、{1} 件の推奨アプリが保留中"
        FilterInfo       = "フィルター: '{0}'"
        AllConfigured    = "すべての推奨アプリはすでに設定されています。"
        AppsConfigured   = "{0} 件のアプリが正常に設定されました。"
        PressEnter       = "[Enterキーを押して続行]"
        NumNotFound      = "[!] 番号 {0} は見つかりませんでした。"
        DoneMessage      = "完了。設定を有効にするには、変更したアプリを再起動してください。"
        SuccessAdd       = "  [+] {0} --> 高パフォーマンス"
        SuccessRemove    = "  [-] {0} --> 削除 (Windows の既定値)"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
        }
    }
    "it" = @{
        Title            = "Gestore delle Preferenze GPU di Windows"
        HighPerf         = "Prestazioni Elevate"
        ReadingUsage     = "Lettura dell'utilizzo della GPU..."
        ColNum           = "#"
        ColApp           = "App"
        ColCategory      = "Categoria"
        ColGpu           = "GPU%"
        ColStatus        = "Stato"
        StatusHigh       = "[OK] Prestazioni Elevate"
        StatusRec        = "[CONSIGLIATO]"
        CatBrowser       = "Browser"
        CatVideo         = "Video"
        Cat3D            = "3D"
        CatDesign        = "Design"
        CatVideoEdit     = "Montaggio Video"
        CatStreaming     = "Streaming"
        CatGames         = "Giochi"
        CatCommunication = "Comunicazione"
        CatDeveloper     = "Sviluppatore"
        CatOther         = "Altro"
        NoAppsFound      = "Nessuna applicazione trovata{0}."
        ForFilter        = " per '{0}'"
        CommandsHeader   = "Comandi:"
        CmdToggle        = "Attiva/disattiva preferenza prestazioni elevate"
        CmdRecApply      = "Applica tutte le app consigliate ({0} in attesa)"
        CmdSearch        = "Filtra elenco"
        CmdAll           = "Cancella filtro"
        CmdQuit          = "Chiudi"
        SummaryInfo      = "Riepilogo: {0} configurate, {1} consigliate in attesa"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Tutte le app consigliate sono già configurate."
        AppsConfigured   = "{0} applicazione/i configurata/e con successo."
        PressEnter       = "[Premi Invio per continuare]"
        NumNotFound      = "[!] Il numero {0} non è stato trovato."
        DoneMessage      = "Fatto. Riavvia le app modificate affinché Windows applichi la nuova preferenza."
        SuccessAdd       = "  [+] {0} --> Prestazioni Elevate"
        SuccessRemove    = "  [-] {0} --> Rimosso (Predefinito di Windows)"
        CommandKeywords  = @{
            Quit   = "esci"
            All    = "tutti"
            Search = "cerca"
            Rec    = "rec"
            Apply  = "applica"
        }
    }
}

# --- AUTOMATIC SYSTEM LANGUAGE DETECTION ---
$systemLang = "en"
try {
    $uiCulture = [System.Globalization.CultureInfo]::CurrentUICulture.Name
    if ($uiCulture -like "pt*") { $systemLang = "pt" }
    elseif ($uiCulture -like "es*") { $systemLang = "es" }
    elseif ($uiCulture -like "fr*") { $systemLang = "fr" }
    elseif ($uiCulture -like "de*") { $systemLang = "de" }
    elseif ($uiCulture -like "zh*") { $systemLang = "zh" }
    elseif ($uiCulture -like "ja*") { $systemLang = "ja" }
    elseif ($uiCulture -like "it*") { $systemLang = "it" }
} catch {}

$langNames = @{
    "en" = "English"
    "pt" = "Português"
    "es" = "Español"
    "fr" = "Français"
    "de" = "Deutsch"
    "zh" = "简体中文"
    "ja" = "日本語"
    "it" = "Italiano"
}

$defaultLangName = $langNames[$systemLang]

# Prompt user for language choice if parameter not passed
if (-not $Language) {
    Clear-Host
    Write-Host ""
    Write-Host "  Select language / Selecione o idioma / Seleccione el idioma:" -ForegroundColor Cyan
    Write-Host "  ===========================================================" -ForegroundColor Cyan
    Write-Host "    [1] English       [2] Português      [3] Español"
    Write-Host "    [4] Français      [5] Deutsch        [6] 简体中文"
    Write-Host "    [7] 日本語        [8] Italiano"
    Write-Host ""
    Write-Host "  Press Enter to auto-detect (Default: $defaultLangName)" -ForegroundColor DarkGray
    Write-Host ""
    $choice = Read-Host "  Language [1-8]"
    $choice = $choice.Trim()
    
    if ($choice -eq "1") { $Language = "en" }
    elseif ($choice -eq "2") { $Language = "pt" }
    elseif ($choice -eq "3") { $Language = "es" }
    elseif ($choice -eq "4") { $Language = "fr" }
    elseif ($choice -eq "5") { $Language = "de" }
    elseif ($choice -eq "6") { $Language = "zh" }
    elseif ($choice -eq "7") { $Language = "ja" }
    elseif ($choice -eq "8") { $Language = "it" }
    else { $Language = $systemLang }
} else {
    $Language = $Language.ToLower()
    if (-not $translations.ContainsKey($Language)) {
        $Language = "en"
    }
}

$txt = $translations[$Language]

# --- APP KNOWLEDGE BASE ---
$appDatabase = @{
    # Browsers
    "chrome"             = @{ Category = "Browser";       Recommended = $true  }
    "firefox"            = @{ Category = "Browser";       Recommended = $true  }
    "librewolf"          = @{ Category = "Browser";       Recommended = $true  }
    "msedge"             = @{ Category = "Browser";       Recommended = $true  }
    "opera"              = @{ Category = "Browser";       Recommended = $true  }
    "brave"              = @{ Category = "Browser";       Recommended = $true  }
    "vivaldi"            = @{ Category = "Browser";       Recommended = $true  }
    "thorium"            = @{ Category = "Browser";       Recommended = $true  }
    "waterfox"           = @{ Category = "Browser";       Recommended = $true  }
    "arc"                = @{ Category = "Browser";       Recommended = $true  }
    "floorp"             = @{ Category = "Browser";       Recommended = $true  }
    "tor"                = @{ Category = "Browser";       Recommended = $true  }
    # Video
    "vlc"                = @{ Category = "Video";         Recommended = $true  }
    "mpc-hc64"           = @{ Category = "Video";         Recommended = $true  }
    "mpc-hc"             = @{ Category = "Video";         Recommended = $true  }
    "mpc-be64"           = @{ Category = "Video";         Recommended = $true  }
    "mpc-be"             = @{ Category = "Video";         Recommended = $true  }
    "mpv"                = @{ Category = "Video";         Recommended = $true  }
    "potplayermini64"    = @{ Category = "Video";         Recommended = $true  }
    "potplayermini"      = @{ Category = "Video";         Recommended = $true  }
    "kmplayer"           = @{ Category = "Video";         Recommended = $true  }
    "gom"                = @{ Category = "Video";         Recommended = $true  }
    "wmplayer"           = @{ Category = "Video";         Recommended = $true  }
    "plex"               = @{ Category = "Video";         Recommended = $true  }
    # Design / 3D / CAD
    "blender"            = @{ Category = "3D";            Recommended = $true  }
    "maya"               = @{ Category = "3D";            Recommended = $true  }
    "3dsmax"             = @{ Category = "3D";            Recommended = $true  }
    "acad"               = @{ Category = "3D";            Recommended = $true  }
    "sldworks"           = @{ Category = "3D";            Recommended = $true  }
    "sketchup"           = @{ Category = "3D";            Recommended = $true  }
    "rhino"              = @{ Category = "3D";            Recommended = $true  }
    "cinema 4d"          = @{ Category = "3D";            Recommended = $true  }
    "photoshop"          = @{ Category = "Design";        Recommended = $true  }
    "illustrator"        = @{ Category = "Design";        Recommended = $true  }
    "lightroom"          = @{ Category = "Design";        Recommended = $true  }
    "indesign"           = @{ Category = "Design";        Recommended = $true  }
    "krita"              = @{ Category = "Design";        Recommended = $true  }
    "gimp-2.10"          = @{ Category = "Design";        Recommended = $true  }
    "gimp"               = @{ Category = "Design";        Recommended = $true  }
    "inkscape"           = @{ Category = "Design";        Recommended = $true  }
    "figma"              = @{ Category = "Design";        Recommended = $true  }
    "clipstudio"         = @{ Category = "Design";        Recommended = $true  }
    "painttoolksa"       = @{ Category = "Design";        Recommended = $true  }
    "sai"                = @{ Category = "Design";        Recommended = $true  }
    "coreldrw"           = @{ Category = "Design";        Recommended = $true  }
    "substance_painter"  = @{ Category = "Design";        Recommended = $true  }
    "marmoset"           = @{ Category = "Design";        Recommended = $true  }
    # Video & Audio Editing
    "premiere"           = @{ Category = "Video Edit";    Recommended = $true  }
    "afterfx"            = @{ Category = "Video Edit";    Recommended = $true  }
    "resolve"            = @{ Category = "Video Edit";    Recommended = $true  }
    "fusion"             = @{ Category = "Video Edit";    Recommended = $true  }
    "vegas130"           = @{ Category = "Video Edit";    Recommended = $true  }
    "vegas"              = @{ Category = "Video Edit";    Recommended = $true  }
    "kdenlive"           = @{ Category = "Video Edit";    Recommended = $true  }
    "handbrake"          = @{ Category = "Video Edit";    Recommended = $true  }
    "audition"           = @{ Category = "Video Edit";    Recommended = $true  }
    # Streaming
    "obs64"              = @{ Category = "Streaming";     Recommended = $true  }
    "obs32"              = @{ Category = "Streaming";     Recommended = $true  }
    "streamlabsobs"      = @{ Category = "Streaming";     Recommended = $true  }
    # Games & Launchers
    "steam"              = @{ Category = "Games";         Recommended = $true  }
    "epicgameslauncher"  = @{ Category = "Games";         Recommended = $true  }
    "leagueclient"       = @{ Category = "Games";         Recommended = $true  }
    "riotclient"         = @{ Category = "Games";         Recommended = $true  }
    "battlenet"          = @{ Category = "Games";         Recommended = $true  }
    "goggalaxy"          = @{ Category = "Games";         Recommended = $true  }
    "galaxyclient"       = @{ Category = "Games";         Recommended = $true  }
    "gameoverlayui"      = @{ Category = "Games";         Recommended = $true  }
    "origin"             = @{ Category = "Games";         Recommended = $true  }
    "eadesktop"          = @{ Category = "Games";         Recommended = $true  }
    "upc"                = @{ Category = "Games";         Recommended = $true  }
    "uplay"              = @{ Category = "Games";         Recommended = $true  }
    "larianlauncher"     = @{ Category = "Games";         Recommended = $true  }
    "minecraft"          = @{ Category = "Games";         Recommended = $true  }
    "javaw"              = @{ Category = "Games";         Recommended = $true  }
    "robloxplayerbeta"   = @{ Category = "Games";         Recommended = $true  }
    "robloxplayer"       = @{ Category = "Games";         Recommended = $true  }
    "robloxstudio"       = @{ Category = "Games";         Recommended = $true  }
    "cs2"                = @{ Category = "Games";         Recommended = $true  }
    "csgo"               = @{ Category = "Games";         Recommended = $true  }
    "valorant-win64-shipping" = @{ Category = "Games";    Recommended = $true  }
    "genshinimpact"      = @{ Category = "Games";         Recommended = $true  }
    "starrail"           = @{ Category = "Games";         Recommended = $true  }
    "fortniteclient-win64-shipping" = @{ Category = "Games"; Recommended = $true  }
    "gta5"               = @{ Category = "Games";         Recommended = $true  }
    "fivem"              = @{ Category = "Games";         Recommended = $true  }
    "cyberpunk2077"      = @{ Category = "Games";         Recommended = $true  }
    "rdr2"               = @{ Category = "Games";         Recommended = $true  }
    # Communication apps with GPU acceleration
    "discord"            = @{ Category = "Communication"; Recommended = $true  }
    "zoom"               = @{ Category = "Communication"; Recommended = $true  }
    "teams"              = @{ Category = "Communication"; Recommended = $false }
    "slack"              = @{ Category = "Communication"; Recommended = $false }
    "telegram"           = @{ Category = "Communication"; Recommended = $false }
    "whatsapp"           = @{ Category = "Communication"; Recommended = $false }
    # Developer tools & Game Engines
    "unity"              = @{ Category = "Developer";     Recommended = $true  }
    "unrealeditor"       = @{ Category = "Developer";     Recommended = $true  }
    "godot"              = @{ Category = "Developer";     Recommended = $true  }
    "code"               = @{ Category = "Developer";     Recommended = $false }
    "devenv"             = @{ Category = "Developer";     Recommended = $false }
    "rider64"            = @{ Category = "Developer";     Recommended = $false }
    "webstorm64"         = @{ Category = "Developer";     Recommended = $false }
    "pycharm64"          = @{ Category = "Developer";     Recommended = $false }
    "idea64"             = @{ Category = "Developer";     Recommended = $false }
    "studio64"           = @{ Category = "Developer";     Recommended = $false }
    "phpstorm64"         = @{ Category = "Developer";     Recommended = $false }
    "cursor"             = @{ Category = "Developer";     Recommended = $false }
}

# System processes hidden from the interactive list
$systemProcessNames = [System.Collections.Generic.HashSet[string]]::new(
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

$gpuPreferenceKey = "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
$highPerformancePreference = 2

if (-not (Test-Path $gpuPreferenceKey)) {
    New-Item -Path $gpuPreferenceKey -Force | Out-Null
}

# ---- FUNCTIONS ----

function Get-GpuPreferenceStatus($path) {
    try {
        $value = (Get-ItemProperty -Path $gpuPreferenceKey -Name $path -ErrorAction Stop).$path
        if ($value -match "GpuPreference=2") { return "high" }
        if ($value -match "GpuPreference=1") { return "power-saving" }
        if ($value -match "GpuPreference=0") { return "default" }
    } catch {}
    return "none"
}

function Get-GpuUsage() {
    $usageByPid = @{}
    try {
        $counters = Get-Counter "\GPU Engine(*engtype_3D*)\Utilization Percentage" `
            -SampleInterval 1 -MaxSamples 1 -ErrorAction Stop
        foreach ($sample in $counters.CounterSamples) {
            if ($sample.CookedValue -gt 0 -and $sample.InstanceName -match "pid_(\d+)") {
                $pid = [int]$Matches[1]
                $percent = [math]::Round($sample.CookedValue, 0)
                if (-not $usageByPid.ContainsKey($pid) -or $usageByPid[$pid] -lt $percent) {
                    $usageByPid[$pid] = $percent
                }
            }
        }
    } catch {}
    return $usageByPid
}

function Get-AppProcesses($filter = "") {
    $processes = Get-Process |
        Where-Object { $_.Path -and -not $systemProcessNames.Contains($_.Name) } |
        Group-Object Path |
        ForEach-Object { $_.Group | Sort-Object Id | Select-Object -First 1 } |
        Sort-Object Name
    if ($filter) {
        $processes = $processes | Where-Object { $_.Name -like "*$filter*" }
    }
    return $processes
}

function Set-HighPerformancePreference($path, $name) {
    Set-ItemProperty -Path $gpuPreferenceKey -Name $path -Value "GpuPreference=$highPerformancePreference;" -Force
    Write-Host ($txt.SuccessAdd -f $name) -ForegroundColor Green
}

function Remove-GpuPreference($path, $name) {
    Remove-ItemProperty -Path $gpuPreferenceKey -Name $path -ErrorAction SilentlyContinue
    Write-Host ($txt.SuccessRemove -f $name) -ForegroundColor DarkYellow
}

# ---- MAIN LOOP ----

$currentFilter = ""

# Category mapper based on selected language
$catMap = @{
    "Browser"       = $txt.CatBrowser
    "Video"         = $txt.CatVideo
    "3D"            = $txt.Cat3D
    "Design"        = $txt.CatDesign
    "Video Edit"    = $txt.CatVideoEdit
    "Streaming"     = $txt.CatStreaming
    "Games"         = $txt.CatGames
    "Communication" = $txt.CatCommunication
    "Developer"     = $txt.CatDeveloper
    "Other"         = $txt.CatOther
}

while ($true) {
    Clear-Host

    Write-Host ""
    Write-Host "  =====================================================" -ForegroundColor Cyan
    Write-Host "    $($txt.Title)   [$($txt.HighPerf)]" -ForegroundColor Cyan
    Write-Host "  =====================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  $($txt.ReadingUsage)" -NoNewline -ForegroundColor DarkGray
    $gpuUsage = Get-GpuUsage
    Write-Host "`r                    `r" -NoNewline

    $processes = Get-AppProcesses $currentFilter
    $indexMap = @{}

    if ($processes.Count -eq 0) {
        $filterMsg = if ($currentFilter) { $txt.ForFilter -f $currentFilter } else { "" }
        Write-Host "  $($txt.NoAppsFound -f $filterMsg)" -ForegroundColor Yellow
    } else {
        Write-Host ("  {0,-4} {1,-26} {2,-14} {3,-6} {4}" -f $txt.ColNum, $txt.ColApp, $txt.ColCategory, $txt.ColGpu, $txt.ColStatus) -ForegroundColor DarkGray
        Write-Host ("  " + [string]::new('-', 68)) -ForegroundColor DarkGray

        $index = 1
        foreach ($process in $processes) {
            $appInfo = $appDatabase[$process.Name.ToLower()]
            $categoryKey = if ($appInfo) { $appInfo.Category } else { "Other" }
            $category = if ($catMap.ContainsKey($categoryKey)) { $catMap[$categoryKey] } else { $categoryKey }
            $recommended = if ($appInfo) { $appInfo.Recommended } else { $false }
            $status = Get-GpuPreferenceStatus $process.Path
            $gpuPercent = if ($gpuUsage.ContainsKey($process.Id)) { "$($gpuUsage[$process.Id])%" } else { "" }

            # Color priority: green = configured, yellow = recommended, gray = uncategorized.
            if ($status -eq "high") {
                $color = "Green";  $tag = $txt.StatusHigh
            } elseif ($recommended) {
                $color = "Yellow"; $tag = $txt.StatusRec
            } elseif ($categoryKey -eq "Other") {
                $color = "DarkGray"; $tag = ""
            } else {
                $color = "White";  $tag = ""
            }

            Write-Host ("  {0,-4} {1,-26} {2,-14} {3,-6} {4}" -f $index, $process.Name, $category, $gpuPercent, $tag) -ForegroundColor $color
            $indexMap[$index] = @{ Process = $process; Recommended = $recommended; Status = $status; Category = $category }
            $index++
        }
    }

    $pendingRecommendedCount = ($indexMap.Values | Where-Object { $_.Recommended -and $_.Status -ne "high" }).Count
    $configuredCount = ($indexMap.Values | Where-Object { $_.Status -eq "high" }).Count
    Write-Host ""
    Write-Host ("  " + [string]::new('-', 68)) -ForegroundColor DarkGray

    # Display Commands with Localized Info
    $cmdRecKey = $txt.CommandKeywords.Rec
    $cmdSearchKey = $txt.CommandKeywords.Search
    $cmdAllKey = $txt.CommandKeywords.All
    $cmdQuitKey = $txt.CommandKeywords.Quit

    Write-Host "  $($txt.CommandsHeader)" -ForegroundColor DarkGray
    Write-Host "    1 / 1,3,5       $($txt.CmdToggle)" -ForegroundColor DarkGray
    Write-Host "    $cmdRecKey / apply     $($txt.CmdRecApply -f $pendingRecommendedCount)" -ForegroundColor DarkGray
    Write-Host "    $cmdSearchKey <text>   $($txt.CmdSearch)" -ForegroundColor DarkGray
    Write-Host "    $cmdAllKey             $($txt.CmdAll)" -ForegroundColor DarkGray
    Write-Host "    $cmdQuitKey            $($txt.CmdQuit)" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  $($txt.SummaryInfo -f $configuredCount, $pendingRecommendedCount)" -ForegroundColor DarkCyan
    if ($currentFilter) { Write-Host "  $($txt.FilterInfo -f $currentFilter)" -ForegroundColor Cyan }
    Write-Host ""

    $commandInput = (Read-Host "  >").Trim().ToLower()

    # Match commands based on English defaults AND localized versions
    $cmdQuit = @("quit", $cmdQuitKey) | Select-Object -Unique
    $cmdAll = @("all", $cmdAllKey) | Select-Object -Unique
    $cmdRecApply = @("rec", "apply", $cmdRecKey, "aplicar", "anwenden", "appliquer") | Select-Object -Unique

    if ($commandInput -in $cmdQuit) { break }

    if ($commandInput -in $cmdAll) { $currentFilter = ""; continue }

    $searchEscaped = [regex]::Escape($cmdSearchKey)
    if ($commandInput -match "^(?:search|$searchEscaped)\s+(.+)") {
        $currentFilter = $Matches[1].Trim()
        continue
    }

    if ($commandInput -in $cmdRecApply) {
        $updatedCount = 0
        foreach ($key in $indexMap.Keys) {
            $item = $indexMap[$key]
            if ($item.Recommended -and $item.Status -ne "high") {
                Set-HighPerformancePreference $item.Process.Path $item.Process.Name
                $updatedCount++
            }
        }
        if ($updatedCount -eq 0) {
            Write-Host "  $($txt.AllConfigured)" -ForegroundColor Green
        } else {
            Write-Host "  $($txt.AppsConfigured -f $updatedCount)" -ForegroundColor Cyan
        }
        Read-Host "  $($txt.PressEnter)"
        continue
    }

    # Numeric input toggles selected apps.
    $numbers = $commandInput -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" }
    if ($numbers.Count -gt 0) {
        foreach ($number in $numbers) {
            $index = [int]$number
            if ($indexMap.ContainsKey($index)) {
                $item = $indexMap[$index]
                if ($item.Status -eq "high") {
                    Remove-GpuPreference $item.Process.Path $item.Process.Name
                } else {
                    Set-HighPerformancePreference $item.Process.Path $item.Process.Name
                }
            } else {
                Write-Host "  $($txt.NumNotFound -f $index)" -ForegroundColor Red
            }
        }
        Read-Host "  $($txt.PressEnter)"
    }
}

Write-Host ""
Write-Host "  $($txt.DoneMessage)" -ForegroundColor Magenta
Write-Host ""


