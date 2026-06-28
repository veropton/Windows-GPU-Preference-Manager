param(
    [Parameter(Mandatory=$false)]
    [string]$Language,

    [Parameter(Mandatory=$false)]
    [string]$Menu
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
        CmdTweaksDesc    = "Windows Gaming Tweaks menu"
        SummaryInfo      = "Summary: {0} configured, {1} recommended pending"
        FilterInfo       = "Filter: '{0}'"
        AllConfigured    = "All recommended apps are already configured."
        AppsConfigured   = "{0} app(s) configured successfully."
        PressEnter       = "[Press Enter to continue]"
        NumNotFound      = "[!] Number {0} was not found."
        DoneMessage      = "Done. Restart changed apps so Windows can apply the new preference."
        SuccessAdd       = "  [+] {0} --> High Performance"
        SuccessRemove    = "  [-] {0} --> Removed (Windows default)"
        TweaksTitle         = "Windows Gaming Performance Tweaks"
        TweakStatusDefault  = "Default"
        TweakStatusOptimized= "Optimized"
        TweakCatServices    = "Services Tuning (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Network & Latency (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Visuals & Power (Ultimate Performance Plan, Visual FX)"
        TweakCatTelemetry   = "Telemetry & Privacy (DiagTrack, Data Collection)"
        TweakCatXbox        = "Xbox Services & Game DVR (Xbox Live, Game Captures)"
        TweakCommandsHeader = "Commands:"
        TweakCmdToggleDesc  = "Toggle specific tweak category (e.g. 1)"
        TweakCmdApplyDesc   = "Apply all selected tweaks"
        TweakCmdRestoreDesc = "Restore all original system configurations"
        TweakCmdBackDesc    = "Go back to main menu"
        MsgAdminRequired    = "[!] Administrator privileges are required to modify system settings."
        MsgAdminConfirmPrompt= "This menu requires Administrator privileges. Would you like to relaunch as Administrator? (y/n)"
        MsgRelaunching      = "Relaunching elevated..."
        MsgBackupCreated    = "Original configuration backup successfully created."
        MsgBackupSkipped    = "Backup file already exists. Skipping backup."
        MsgTweaksApplied    = "Gaming tweaks applied successfully!"
        MsgRestoreSuccess   = "System settings successfully restored to original configuration."
        MsgNoBackupFound    = "No backup file found. Cannot restore."
        MsgTweakSuccess     = "  [+] {0} --> Optimized"
        MsgRestoreService   = "  [-] Service {0} restored to {1}"
        MsgRestoreRegistry  = "  [-] Registry path {0} restored"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
            Tweaks = "tweaks"
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
        CmdTweaksDesc    = "Menu de otimizações de jogos do Windows"
        SummaryInfo      = "Resumo: {0} configurado(s), {1} recomendado(s) pendente(s)"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Todos os apps recomendados já estão configurados."
        AppsConfigured   = "{0} app(s) configurado(s) com sucesso."
        PressEnter       = "[Pressione Enter para continuar]"
        NumNotFound      = "[!] Número {0} não foi encontrado."
        DoneMessage      = "Concluído. Reinicie os apps alterados para que o Windows aplique a nova preferência."
        SuccessAdd       = "  [+] {0} --> Alto Desempenho"
        SuccessRemove    = "  [-] {0} --> Removido (Padrão do Windows)"
        TweaksTitle         = "Otimizações de Desempenho de Jogo do Windows"
        TweakStatusDefault  = "Padrão"
        TweakStatusOptimized= "Otimizado"
        TweakCatServices    = "Ajuste de Serviços (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Rede e Latência (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Visual e Energia (Plano de Desempenho Máximo, Visual FX)"
        TweakCatTelemetry   = "Telemetria e Privacidade (DiagTrack, Data Collection)"
        TweakCatXbox        = "Serviços Xbox e Game DVR (Xbox Live, Capturas de Jogo)"
        TweakCommandsHeader = "Comandos:"
        TweakCmdToggleDesc  = "Alternar categoria de tweak específica (ex: 1)"
        TweakCmdApplyDesc   = "Aplicar todos os tweaks selecionados"
        TweakCmdRestoreDesc = "Restaurar todas as configurações originais do sistema"
        TweakCmdBackDesc    = "Voltar ao menu principal"
        MsgAdminRequired    = "[!] Privilégios de Administrador são necessários para modificar configurações do sistema."
        MsgAdminConfirmPrompt= "Este menu requer privilégios de Administrador. Gostaria de reiniciar como Administrador? (s/n)"
        MsgRelaunching      = "Reiniciando com privilégios de administrador..."
        MsgBackupCreated    = "Backup das configurações originais criado com sucesso."
        MsgBackupSkipped    = "O arquivo de backup já existe. Ignorando backup."
        MsgTweaksApplied    = "Otimizações de jogos aplicadas com sucesso!"
        MsgRestoreSuccess   = "Configurações do sistema restauradas com sucesso para a configuração original."
        MsgNoBackupFound    = "Nenhum arquivo de backup encontrado. Não é possível restaurar."
        MsgTweakSuccess     = "  [+] {0} --> Otimizado"
        MsgRestoreService   = "  [-] Serviço {0} restaurado para {1}"
        MsgRestoreRegistry  = "  [-] Registro {0} restaurado"
        CommandKeywords  = @{
            Quit   = "sair"
            All    = "todos"
            Search = "busca"
            Rec    = "rec"
            Apply  = "aplicar"
            Tweaks = "ajustes"
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
        CmdTweaksDesc    = "Menú de optimizaciones de juegos de Windows"
        SummaryInfo      = "Resumen: {0} configurado(s), {1} recomendado(s) pendiente(s)"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Todas las aplicaciones recomendadas ya están configuradas."
        AppsConfigured   = "{0} aplicación(es) configurada(s) con éxito."
        PressEnter       = "[Presione Enter para continuar]"
        NumNotFound      = "[!] El número {0} no fue encontrado."
        DoneMessage      = "Hecho. Reinicie las aplicaciones cambiadas para que Windows aplique la nueva preferencia."
        SuccessAdd       = "  [+] {0} --> Alto Rendimiento"
        SuccessRemove    = "  [-] {0} --> Eliminado (Predeterminado de Windows)"
        TweaksTitle         = "Optimizaciones de Rendimiento de Juego de Windows"
        TweakStatusDefault  = "Predeterminado"
        TweakStatusOptimized= "Optimizado"
        TweakCatServices    = "Ajuste de Servicios (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Red y Latencia (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Visual y Energía (Plan de Rendimiento Máximo, Visual FX)"
        TweakCatTelemetry   = "Telemetría y Privacidad (DiagTrack, Data Collection)"
        TweakCatXbox        = "Servicios Xbox y Game DVR (Xbox Live, Capturas de Juego)"
        TweakCommandsHeader = "Comandos:"
        TweakCmdToggleDesc  = "Alternar categoría de optimización específica (ej. 1)"
        TweakCmdApplyDesc   = "Aplicar todas las optimizaciones seleccionadas"
        TweakCmdRestoreDesc = "Restaurar todas las configuraciones originales del sistema"
        TweakCmdBackDesc    = "Volver al menú principal"
        MsgAdminRequired    = "[!] Se requieren privilegios de Administrador para modificar la configuración del sistema."
        MsgAdminConfirmPrompt= "Este menú requiere privilegios de Administrador. ¿Desea reiniciar como Administrador? (s/n)"
        MsgRelaunching      = "Reiniciando con privilegios de administrador..."
        MsgBackupCreated    = "Copia de seguridad de la configuración original creada con éxito."
        MsgBackupSkipped    = "El archivo de copia de seguridad ya existe. Omitiendo copia."
        MsgTweaksApplied    = "¡Optimizaciones de juego aplicadas con éxito!"
        MsgRestoreSuccess   = "Configuración del sistema restaurada con éxito a la configuración original."
        MsgNoBackupFound    = "No se encontró ningún archivo de copia de seguridad. No se puede restaurar."
        MsgTweakSuccess     = "  [+] {0} --> Optimizado"
        MsgRestoreService   = "  [-] Servicio {0} restaurado a {1}"
        MsgRestoreRegistry  = "  [-] Registro {0} restaurado"
        CommandKeywords  = @{
            Quit   = "salir"
            All    = "todos"
            Search = "buscar"
            Rec    = "rec"
            Apply  = "aplicar"
            Tweaks = "optimizaciones"
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
        CmdTweaksDesc    = "Menu des optimisations de jeux Windows"
        SummaryInfo      = "Résumé : {0} configurée(s), {1} recommandée(s) en attente"
        FilterInfo       = "Filtre : '{0}'"
        AllConfigured    = "Toutes les applications recommandées sont déjà configurées."
        AppsConfigured   = "{0} application(s) configurée(s) avec succès."
        PressEnter       = "[Appuyez sur Entrée pour continuer]"
        NumNotFound      = "[!] Le numéro {0} n'a pas été trouvé."
        DoneMessage      = "Terminé. Redémarrez les applications modifiées pour que Windows applique la nouvelle préférence."
        SuccessAdd       = "  [+] {0} --> Performances Élevées"
        SuccessRemove    = "  [-] {0} --> Supprimé (Par défaut de Windows)"
        TweaksTitle         = "Optimisations des Performances de Jeu Windows"
        TweakStatusDefault  = "Par défaut"
        TweakStatusOptimized= "Optimisé"
        TweakCatServices    = "Ajustement des Services (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Réseau et Latence (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Visuel et Alimentation (Performances Ultimes, Visual FX)"
        TweakCatTelemetry   = "Télémétrie et Confidentialité (DiagTrack, Data Collection)"
        TweakCatXbox        = "Services Xbox et Game DVR (Xbox Live, Captures de Jeu)"
        TweakCommandsHeader = "Commandes :"
        TweakCmdToggleDesc  = "Basculer une catégorie d'optimisation (ex. 1)"
        TweakCmdApplyDesc   = "Appliquer toutes les optimisations sélectionnées"
        TweakCmdRestoreDesc = "Restaurer toutes les configurations système d'origine"
        TweakCmdBackDesc    = "Retour au menu principal"
        MsgAdminRequired    = "[!] Les privilèges d'Administrateur sont requis pour modifier les paramètres système."
        MsgAdminConfirmPrompt= "Ce menu nécessite des privilèges d'Administrateur. Souhaitez-vous redémarrer en tant qu'Administrateur ? (o/n)"
        MsgRelaunching      = "Redémarrage avec privilèges d'administrateur..."
        MsgBackupCreated    = "Sauvegarde de la configuration d'origine créée avec succès."
        MsgBackupSkipped    = "Le fichier de sauvegarde existe déjà. Sauvegarde ignorée."
        MsgTweaksApplied    = "Optimisations de jeu appliquées avec succès !"
        MsgRestoreSuccess   = "Paramètres système restaurés avec succès à la configuration d'origine."
        MsgNoBackupFound    = "Aucun fichier de sauvegarde trouvé. Impossible de restaurer."
        MsgTweakSuccess     = "  [+] {0} --> Optimisé"
        MsgRestoreService   = "  [-] Service {0} restauré sur {1}"
        MsgRestoreRegistry  = "  [-] Registre {0} restauré"
        CommandKeywords  = @{
            Quit   = "quitter"
            All    = "tout"
            Search = "recherche"
            Rec    = "rec"
            Apply  = "appliquer"
            Tweaks = "optimisations"
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
        CmdTweaksDesc    = "Windows Gaming-Leistungsoptimierungsmenü"
        SummaryInfo      = "Zusammenfassung: {0} konfiguriert, {1} empfohlen ausstehend"
        FilterInfo       = "Filter: '{0}'"
        AllConfigured    = "Alle empfohlenen Apps sind bereits konfiguriert."
        AppsConfigured   = "{0} App(s) erfolgreich konfiguriert."
        PressEnter       = "[Eingabetaste drücken, um fortzufahren]"
        NumNotFound      = "[!] Nummer {0} wurde nicht gefunden."
        DoneMessage      = "Fertig. Starten Sie geänderte Apps neu, damit Windows die neue Präferenz übernehmen kann."
        SuccessAdd       = "  [+] {0} --> Hohe Leistung"
        SuccessRemove    = "  [-] {0} --> Entfernt (Windows-Standard)"
        TweaksTitle         = "Windows Gaming-Leistungsoptimierungen"
        TweakStatusDefault  = "Standard"
        TweakStatusOptimized= "Optimiert"
        TweakCatServices    = "Dienste-Tuning (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Netzwerk & Latenz (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Visuelles & Energie (Ultimative Leistung, Visual FX)"
        TweakCatTelemetry   = "Telemetrie & Datenschutz (DiagTrack, Datensammlung)"
        TweakCatXbox        = "Xbox-Dienste & Game DVR (Xbox Live, Spieleaufnahmen)"
        TweakCommandsHeader = "Befehle:"
        TweakCmdToggleDesc  = "Spezifische Optimierungskategorie umschalten (z. B. 1)"
        TweakCmdApplyDesc   = "Alle ausgewählten Optimierungen anwenden"
        TweakCmdRestoreDesc = "Alle Originalsystemkonfigurationen wiederherstellen"
        TweakCmdBackDesc    = "Zurück zum Hauptmenü"
        MsgAdminRequired    = "[!] Administratorrechte sind erforderlich, um Systemeinstellungen zu ändern."
        MsgAdminConfirmPrompt= "Dieses Menü erfordert Administratorrechte. Möchten Sie als Administrator neu starten? (j/n)"
        MsgRelaunching      = "Neu starten mit Administratorrechten..."
        MsgBackupCreated    = "Sicherung der Originalkonfiguration erfolgreich erstellt."
        MsgBackupSkipped    = "Sicherungsdatei existiert bereits. Sicherung übersprungen."
        MsgTweaksApplied    = "Gaming-Leistungsoptimierungen erfolgreich angewendet!"
        MsgRestoreSuccess   = "Systemeinstellungen erfolgreich auf Originalkonfiguration zurückgesetzt."
        MsgNoBackupFound    = "Keine Sicherungsdatei gefunden. Wiederherstellung nicht möglich."
        MsgTweakSuccess     = "  [+] {0} --> Optimiert"
        MsgRestoreService   = "  [-] Dienst {0} auf {1} zurückgesetzt"
        MsgRestoreRegistry  = "  [-] Registrierung {0} wiederhergestellt"
        CommandKeywords  = @{
            Quit   = "beenden"
            All    = "alle"
            Search = "suche"
            Rec    = "rec"
            Apply  = "anwenden"
            Tweaks = "optimierungen"
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
        CmdTweaksDesc    = "Windows 游戏性能优化菜单"
        SummaryInfo      = "摘要: {0} 已配置, {1} 个推荐待处理"
        FilterInfo       = "过滤器: '{0}'"
        AllConfigured    = "所有推荐的应用都已配置。"
        AppsConfigured   = "{0} 个应用配置成功。"
        PressEnter       = "[按回车键继续]"
        NumNotFound      = "[!] 未找到数字 {0}。"
        DoneMessage      = "完成。请重启更改的应用，以便 Windows 应用新的首选项。"
        SuccessAdd       = "  [+] {0} --> 高性能"
        SuccessRemove    = "  [-] {0} --> 已移除 (Windows 默认)"
        TweaksTitle         = "Windows 游戏性能优化"
        TweakStatusDefault  = "默认"
        TweakStatusOptimized= "已优化"
        TweakCatServices    = "服务调整 (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "网络和延迟 (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "视觉和电源 (卓越性能电源计划, Visual FX)"
        TweakCatTelemetry   = "遥测和隐私 (DiagTrack, 数据收集)"
        TweakCatXbox        = "Xbox 服务和游戏 DVR (Xbox Live, 游戏捕获)"
        TweakCommandsHeader = "命令:"
        TweakCmdToggleDesc  = "切换特定优化类别 (例如 1)"
        TweakCmdApplyDesc   = "应用所有选定的优化"
        TweakCmdRestoreDesc = "还原所有原始系统配置"
        TweakCmdBackDesc    = "返回主菜单"
        MsgAdminRequired    = "[!] 修改系统设置需要管理员权限。"
        MsgAdminConfirmPrompt= "此菜单需要管理员权限。是否要以管理员身份重新启动？(y/n)"
        MsgRelaunching      = "正在以管理员身份重新启动..."
        MsgBackupCreated    = "成功创建原始配置备份。"
        MsgBackupSkipped    = "备份文件已存在。跳过备份。"
        MsgTweaksApplied    = "游戏性能优化应用成功！"
        MsgRestoreSuccess   = "系统设置成功恢复为原始配置。"
        MsgNoBackupFound    = "未找到备份文件。无法恢复。"
        MsgTweakSuccess     = "  [+] {0} --> 已优化"
        MsgRestoreService   = "  [-] 服务 {0} 已恢复为 {1}"
        MsgRestoreRegistry  = "  [-] 注册表路径 {0} 已恢复"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
            Tweaks = "tweaks"
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
        CmdTweaksDesc    = "Windows ゲーム最適化メニュー"
        SummaryInfo      = "概要: {0} 件設定済み、{1} 件の推奨アプリが保留中"
        FilterInfo       = "フィルター: '{0}'"
        AllConfigured    = "すべての推奨アプリはすでに設定されています。"
        AppsConfigured   = "{0} 件のアプリが正常に設定されました。"
        PressEnter       = "[Enterキーを押して続行]"
        NumNotFound      = "[!] 番号 {0} は見つかりませんでした。"
        DoneMessage      = "完了。設定を有効にするには、変更したアプリを再起動してください。"
        SuccessAdd       = "  [+] {0} --> 高パフォーマンス"
        SuccessRemove    = "  [-] {0} --> 削除 (Windows の既定値)"
        TweaksTitle         = "Windows ゲーム性能最適化"
        TweakStatusDefault  = "既定"
        TweakStatusOptimized= "最適化済み"
        TweakCatServices    = "サービス調整 (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "ネットワークと遅延 (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "ビジュアルと電源 (究極のパフォーマンス電源計画, Visual FX)"
        TweakCatTelemetry   = "テレメトリとプライバシー (DiagTrack, データ収集)"
        TweakCatXbox        = "Xbox サービスとゲーム DVR (Xbox Live, ゲームキャプチャ)"
        TweakCommandsHeader = "コマンド:"
        TweakCmdToggleDesc  = "特定の最適化カテゴリの切り替え (例: 1)"
        TweakCmdApplyDesc   = "選択したすべての最適化を適用"
        TweakCmdRestoreDesc = "すべての元のシステム設定を復元"
        TweakCmdBackDesc    = "メインメニューに戻る"
        MsgAdminRequired    = "[!] システム設定を変更するには、管理者権限が必要です。"
        MsgAdminConfirmPrompt= "このメニューには管理者権限が必要です。管理者として再起動しますか？(y/n)"
        MsgRelaunching      = "管理者権限で再起動中..."
        MsgBackupCreated    = "元の設定のバックアップが正常に作成されました。"
        MsgBackupSkipped    = "バックアップファイルはすでに存在します。バックアップをスキップします。"
        MsgTweaksApplied    = "ゲーム最適化が正常に適用されました！"
        MsgRestoreSuccess   = "システム設定が元の設定に正常に復元されました。"
        MsgNoBackupFound    = "バックアップファイルが見つかりません。復元できません。"
        MsgTweakSuccess     = "  [+] {0} --> 最適化済み"
        MsgRestoreService   = "  [-] サービス {0} を {1} に復元しました"
        MsgRestoreRegistry  = "  [-] レジストリパス {0} を復元しました"
        CommandKeywords  = @{
            Quit   = "quit"
            All    = "all"
            Search = "search"
            Rec    = "rec"
            Apply  = "apply"
            Tweaks = "tweaks"
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
        CmdTweaksDesc    = "Menu delle ottimizzazioni di gioco di Windows"
        SummaryInfo      = "Riepilogo: {0} configurate, {1} consigliate in attesa"
        FilterInfo       = "Filtro: '{0}'"
        AllConfigured    = "Tutte le app consigliate sono già configurate."
        AppsConfigured   = "{0} applicazione/i configurata/e con successo."
        PressEnter       = "[Premi Invio per continuare]"
        NumNotFound      = "[!] Il numero {0} non è stato trovato."
        DoneMessage      = "Fatto. Riavvia le app modificate affinché Windows applichi la nuova preferenza."
        SuccessAdd       = "  [+] {0} --> Prestazioni Elevate"
        SuccessRemove    = "  [-] {0} --> Rimosso (Predefinito di Windows)"
        TweaksTitle         = "Ottimizzazioni delle Prestazioni di Gioco di Windows"
        TweakStatusDefault  = "Predefinito"
        TweakStatusOptimized= "Ottimizzato"
        TweakCatServices    = "Ottimizzazione Servizi (Print Spooler, Fax, SysMain, WerSvc)"
        TweakCatNetwork     = "Rete e Latenza (TcpNoDelay, Network Throttling)"
        TweakCatVisuals     = "Aspetto ed Energia (Prestazioni Eccellenti, Visual FX)"
        TweakCatTelemetry   = "Telemetria e Privacy (DiagTrack, Data Collection)"
        TweakCatXbox        = "Servizi Xbox e Game DVR (Xbox Live, Catture di Gioco)"
        TweakCommandsHeader = "Comandi:"
        TweakCmdToggleDesc  = "Attiva/disattiva categoria ottimizzazione specifica (es. 1)"
        TweakCmdApplyDesc   = "Applica tutte le ottimizzazioni selezionate"
        TweakCmdRestoreDesc = "Ripristina tutte le configurazioni di sistema originali"
        TweakCmdBackDesc    = "Torna al menu principale"
        MsgAdminRequired    = "[!] Sono richiesti i privilegi di Amministratore per modificare le impostazioni di sistema."
        MsgAdminConfirmPrompt= "Questo menu richiede i privilegi di Amministratore. Vuoi riavviare come Amministratore? (s/n)"
        MsgRelaunching      = "Riavvio con privilegi di amministratore..."
        MsgBackupCreated    = "Backup della configurazione originale creato con successo."
        MsgBackupSkipped    = "Il file di backup esiste già. Backup saltato."
        MsgTweaksApplied    = "Ottimizzazioni di gioco applicate con successo!"
        MsgRestoreSuccess   = "Impostazioni di sistema ripristinate con successo alla configurazione originale."
        MsgNoBackupFound    = "Nessun file di backup trovato. Impossibile ripristinare."
        MsgTweakSuccess     = "  [+] {0} --> Ottimizzato"
        MsgRestoreService   = "  [-] Servizio {0} ripristinato a {1}"
        MsgRestoreRegistry  = "  [-] Registro {0} ripristinato"
        CommandKeywords  = @{
            Quit   = "esci"
            All    = "tutti"
            Search = "cerca"
            Rec    = "rec"
            Apply  = "applica"
            Tweaks = "ottimizzazioni"
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

if ($Menu -eq "tweaks") {
    Show-TweaksMenu
    exit
}

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

# File path for backup
$backupFilePath = Join-Path $PSScriptRoot ".sgp-backup.json"
# Fallback to AppData if the directory is read-only
if (-not $PSScriptRoot -or -not [IO.Directory]::Exists($PSScriptRoot)) {
    $backupFilePath = Join-Path $env:APPDATA "SmartGraphicsPreference\.sgp-backup.json"
}

# Ensure parent directory exists for backup path
$backupDir = Split-Path $backupFilePath
if (-not (Test-Path $backupDir)) {
    New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
}

function Test-IsAdmin() {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Relaunch-AsAdmin($subMenu = "") {
    Write-Host $txt.MsgRelaunching -ForegroundColor Yellow
    $argsList = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Language) { $argsList += " -Language $Language" }
    if ($subMenu) { $argsList += " -Menu $subMenu" }
    
    try {
        Start-Process powershell.exe -ArgumentList $argsList -Verb RunAs
        exit
    } catch {
        Write-Host "[!] Relaunch failed. Please run PowerShell as Administrator." -ForegroundColor Red
        Read-Host $txt.PressEnter
    }
}

# --- TWEAK CHECKERS ---

function Get-TweakStatus-Services() {
    $nonDisabled = Get-Service -Name Spooler, Fax, SysMain, WerSvc -ErrorAction SilentlyContinue | 
        Where-Object { $_.StartType -ne "Disabled" }
    if ($null -eq $nonDisabled -or $nonDisabled.Count -eq 0) {
        return "Optimized"
    }
    return "Default"
}

function Get-TweakStatus-Network() {
    $profileKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    try {
        $throttling = (Get-ItemProperty -Path $profileKey -Name NetworkThrottlingIndex -ErrorAction Stop).NetworkThrottlingIndex
        $responsiveness = (Get-ItemProperty -Path $profileKey -Name SystemResponsiveness -ErrorAction Stop).SystemResponsiveness
        if ($throttling -eq 4294967295 -and $responsiveness -eq 0) {
            return "Optimized"
        }
    } catch {}
    return "Default"
}

function Get-TweakStatus-Visuals() {
    $visualOptimized = $false
    try {
        $visualVal = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -ErrorAction Stop).VisualFXSetting
        if ($visualVal -eq 2) { $visualOptimized = $true }
    } catch {}

    $powerOptimized = $false
    try {
        $activeScheme = (powercfg /getactivescheme) -match "GUID:\s+([a-fA-F0-9-]+)"
        if ($Matches[1] -eq "e9a22d33-57a2-470a-a316-641617eb04b1") {
            $powerOptimized = $true
        }
    } catch {}

    if ($visualOptimized -and $powerOptimized) {
        return "Optimized"
    }
    return "Default"
}

function Get-TweakStatus-Telemetry() {
    $telemetryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    $telemetryOptimized = $false
    try {
        $val = (Get-ItemProperty -Path $telemetryKey -Name AllowTelemetry -ErrorAction Stop).AllowTelemetry
        if ($val -eq 0) { $telemetryOptimized = $true }
    } catch {}

    $diagTrackDisabled = $false
    try {
        $svc = Get-Service -Name DiagTrack -ErrorAction Stop
        if ($svc.StartType -eq "Disabled") { $diagTrackDisabled = $true }
    } catch {}

    if ($telemetryOptimized -and $diagTrackDisabled) {
        return "Optimized"
    }
    return "Default"
}

function Get-TweakStatus-Xbox() {
    $gameDvrOptimized = $false
    try {
        $val1 = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -ErrorAction Stop).AppCaptureEnabled
        $val2 = (Get-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -ErrorAction Stop).GameDVR_Enabled
        if ($val1 -eq 0 -and $val2 -eq 0) { $gameDvrOptimized = $true }
    } catch {}

    $xboxSvcDisabled = $false
    try {
        $nonDisabled = Get-Service -Name XblAuthManager, XblGameSave, XboxNetApiSvc -ErrorAction SilentlyContinue |
            Where-Object { $_.StartType -ne "Disabled" }
        if ($null -eq $nonDisabled -or $nonDisabled.Count -eq 0) {
            $xboxSvcDisabled = $true
        }
    } catch {}

    if ($gameDvrOptimized -and $xboxSvcDisabled) {
        return "Optimized"
    }
    return "Default"
}

# --- BACKUP MANAGEMENT ---

function Load-Backup() {
    if (Test-Path $backupFilePath) {
        try {
            $json = Get-Content -Raw -Path $backupFilePath -ErrorAction Stop
            return ConvertFrom-Json $json
        } catch {}
    }
    return [PSCustomObject]@{
        Services = [Ordered]@{}
        Registry = [Ordered]@{}
        PowerScheme = $null
    }
}

function Save-Backup($backup) {
    try {
        $json = ConvertTo-Json $backup -Depth 5
        $json | Out-File -FilePath $backupFilePath -Encoding UTF8 -Force
    } catch {
        Write-Host "[!] Failed to write backup: $_" -ForegroundColor Red
    }
}

function Add-RegistryBackup($backup, $path, $name) {
    if ($null -eq $backup.Registry) {
        $backup.Registry = [Ordered]@{}
    }
    $fullKey = "$path\$name"
    # Convert to standard key name
    if (-not $backup.Registry.PSObject.Properties[$fullKey]) {
        $val = $null
        try {
            $val = (Get-ItemProperty -Path $path -Name $name -ErrorAction Stop).$name
        } catch {}
        $backup.Registry | Add-Member -MemberType NoteProperty -Name $fullKey -Value $val -Force
    }
}

function Add-ServiceBackup($backup, $serviceName) {
    if ($null -eq $backup.Services) {
        $backup.Services = [Ordered]@{}
    }
    if (-not $backup.Services.PSObject.Properties[$serviceName]) {
        try {
            $svc = Get-Service -Name $serviceName -ErrorAction Stop
            $backup.Services | Add-Member -MemberType NoteProperty -Name $serviceName -Value $svc.StartType.ToString() -Force
        } catch {}
    }
}

# --- TWEAK APPLICATIONS ---

function Apply-Tweak-Services() {
    $backup = Load-Backup
    $services = @("Spooler", "Fax", "SysMain", "WerSvc")
    foreach ($svcName in $services) {
        Add-ServiceBackup $backup $svcName
        try {
            Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svcName -StartupType Disabled -ErrorAction Stop
            Write-Host ($txt.MsgTweakSuccess -f "Service $svcName") -ForegroundColor Green
        } catch {
            Write-Host "  [!] Failed to disable $svcName" -ForegroundColor Red
        }
    }
    Save-Backup $backup
}

function Apply-Tweak-Network() {
    $backup = Load-Backup
    
    $profileKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Add-RegistryBackup $backup $profileKey "NetworkThrottlingIndex"
    Add-RegistryBackup $backup $profileKey "SystemResponsiveness"
    Set-ItemProperty -Path $profileKey -Name "NetworkThrottlingIndex" -Value 4294967295 -Type DWord -Force | Out-Null
    Set-ItemProperty -Path $profileKey -Name "SystemResponsiveness" -Value 0 -Type DWord -Force | Out-Null
    Write-Host ($txt.MsgTweakSuccess -f "Multimedia Profile Settings") -ForegroundColor Green

    $interfacesKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    $interfaces = Get-ChildItem -Path $interfacesKey
    foreach ($iface in $interfaces) {
        $path = $iface.PSPath
        $hasIP = $null
        try {
            $hasIP = Get-ItemProperty -Path $path -Name "DhcpIPAddress", "IPAddress" -ErrorAction SilentlyContinue
        } catch {}
        if ($hasIP) {
            Add-RegistryBackup $backup $path "TcpAckFrequency"
            Add-RegistryBackup $backup $path "TcpNoDelay"
            Set-ItemProperty -Path $path -Name "TcpAckFrequency" -Value 1 -Type DWord -Force | Out-Null
            Set-ItemProperty -Path $path -Name "TcpNoDelay" -Value 1 -Type DWord -Force | Out-Null
        }
    }
    Write-Host ($txt.MsgTweakSuccess -f "TCP Latency Settings (Nagle's Algorithm)") -ForegroundColor Green
    
    Save-Backup $backup
}

function Apply-Tweak-Visuals() {
    $backup = Load-Backup

    $visualKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    if (-not (Test-Path $visualKey)) {
        New-Item -Path $visualKey -Force | Out-Null
    }
    Add-RegistryBackup $backup $visualKey "VisualFXSetting"
    Set-ItemProperty -Path $visualKey -Name "VisualFXSetting" -Value 2 -Type DWord -Force | Out-Null
    Write-Host ($txt.MsgTweakSuccess -f "Visual FX Settings (Best Performance)") -ForegroundColor Green

    if ($null -eq $backup.PowerScheme) {
        try {
            $activeScheme = (powercfg /getactivescheme) -match "GUID:\s+([a-fA-F0-9-]+)"
            $backup.PowerScheme = $Matches[1]
        } catch {}
    }
    
    $plans = powercfg /list
    $ultimateGuid = "e9a22d33-57a2-470a-a316-641617eb04b1"
    if ($plans -notmatch $ultimateGuid) {
        try {
            powercfg /duplicatescheme $ultimateGuid | Out-Null
        } catch {
            try {
                powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
            } catch {}
        }
    }
    
    try {
        powercfg /setactive $ultimateGuid | Out-Null
        Write-Host ($txt.MsgTweakSuccess -f "Power Plan (Ultimate Performance)") -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to set active power scheme" -ForegroundColor Red
    }

    Save-Backup $backup
}

function Apply-Tweak-Telemetry() {
    $backup = Load-Backup

    $policyKey1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $policyKey1)) { New-Item -Path $policyKey1 -Force | Out-Null }
    Add-RegistryBackup $backup $policyKey1 "AllowTelemetry"
    Set-ItemProperty -Path $policyKey1 -Name "AllowTelemetry" -Value 0 -Type DWord -Force | Out-Null

    $policyKey2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    if (-not (Test-Path $policyKey2)) { New-Item -Path $policyKey2 -Force | Out-Null }
    Add-RegistryBackup $backup $policyKey2 "AllowTelemetry"
    Set-ItemProperty -Path $policyKey2 -Name "AllowTelemetry" -Value 0 -Type DWord -Force | Out-Null
    Write-Host ($txt.MsgTweakSuccess -f "System Telemetry Policies") -ForegroundColor Green

    Add-ServiceBackup $backup "DiagTrack"
    try {
        Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction Stop
        Write-Host ($txt.MsgTweakSuccess -f "Service DiagTrack") -ForegroundColor Green
    } catch {
        Write-Host "  [!] Failed to disable DiagTrack service" -ForegroundColor Red
    }

    Save-Backup $backup
}

function Apply-Tweak-Xbox() {
    $backup = Load-Backup

    $dvrKey1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
    if (-not (Test-Path $dvrKey1)) { New-Item -Path $dvrKey1 -Force | Out-Null }
    Add-RegistryBackup $backup $dvrKey1 "AppCaptureEnabled"
    Set-ItemProperty -Path $dvrKey1 -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force | Out-Null

    $dvrKey2 = "HKCU:\System\GameConfigStore"
    if (-not (Test-Path $dvrKey2)) { New-Item -Path $dvrKey2 -Force | Out-Null }
    Add-RegistryBackup $backup $dvrKey2 "GameDVR_Enabled"
    Set-ItemProperty -Path $dvrKey2 -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force | Out-Null
    Write-Host ($txt.MsgTweakSuccess -f "Game DVR settings") -ForegroundColor Green

    $xboxServices = @("XblAuthManager", "XblGameSave", "XboxNetApiSvc")
    foreach ($svcName in $xboxServices) {
        Add-ServiceBackup $backup $svcName
        try {
            Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svcName -StartupType Disabled -ErrorAction Stop
            Write-Host ($txt.MsgTweakSuccess -f "Service $svcName") -ForegroundColor Green
        } catch {
            Write-Host "  [!] Failed to disable $svcName" -ForegroundColor Red
        }
    }

    Save-Backup $backup
}

# --- RESTORE TWEAKS ---

function Restore-Tweaks() {
    if (-not (Test-Path $backupFilePath)) {
        Write-Host $txt.MsgNoBackupFound -ForegroundColor Red
        Read-Host $txt.PressEnter
        return
    }

    $backup = Load-Backup
    Write-Host ""
    Write-Host "  Restoring original configurations..." -ForegroundColor Cyan
    Write-Host ("  " + [string]::new('-', 50)) -ForegroundColor DarkGray

    if ($backup.Services) {
        foreach ($prop in $backup.Services.PSObject.Properties) {
            $svcName = $prop.Name
            $startType = $prop.Value
            try {
                Set-Service -Name $svcName -StartupType $startType -ErrorAction Stop
                if ($startType -eq "Automatic" -or $startType -eq "AutomaticDelayedStart") {
                    Start-Service -Name $svcName -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Host ($txt.MsgRestoreService -f $svcName, $startType) -ForegroundColor Green
            } catch {
                Write-Host "  [!] Failed to restore service $svcName to $startType" -ForegroundColor Red
            }
        }
    }

    if ($backup.Registry) {
        foreach ($prop in $backup.Registry.PSObject.Properties) {
            $fullKey = $prop.Name
            $origVal = $prop.Value
            $lastIndex = $fullKey.LastIndexOf("\")
            if ($lastIndex -gt 0) {
                $path = $fullKey.Substring(0, $lastIndex)
                $name = $fullKey.Substring($lastIndex + 1)
                
                try {
                    if ($null -eq $origVal) {
                        Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Out-Null
                    } else {
                        $type = "String"
                        if ($origVal -match "^\d+$" -or $origVal.GetType().Name -match "Int") { $type = "DWord" }
                        Set-ItemProperty -Path $path -Name $name -Value $origVal -Type $type -Force -ErrorAction Stop | Out-Null
                    }
                    Write-Host ($txt.MsgRestoreRegistry -f $fullKey) -ForegroundColor Green
                } catch {
                    Write-Host "  [!] Failed to restore registry key $fullKey" -ForegroundColor Red
                }
            }
        }
    }

    if ($backup.PowerScheme) {
        try {
            powercfg /setactive $backup.PowerScheme | Out-Null
            Write-Host "  [-] Active Power Plan restored" -ForegroundColor Green
        } catch {
            Write-Host "  [!] Failed to restore original power scheme" -ForegroundColor Red
        }
    }

    Remove-Item -Path $backupFilePath -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host $txt.MsgRestoreSuccess -ForegroundColor Green
    Read-Host $txt.PressEnter
}

function Restore-Category($category) {
    if (-not (Test-Path $backupFilePath)) {
        Write-Host "  [-] No backup file. Applying default fallback values..." -ForegroundColor Yellow
        if ($category -eq "Services") {
            Set-Service -Name Spooler -StartupType Automatic -ErrorAction SilentlyContinue
            Set-Service -Name Fax -StartupType Manual -ErrorAction SilentlyContinue
            Set-Service -Name SysMain -StartupType Automatic -ErrorAction SilentlyContinue
            Set-Service -Name WerSvc -StartupType Manual -ErrorAction SilentlyContinue
        }
        elseif ($category -eq "Network") {
            $profileKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
            Set-ItemProperty -Path $profileKey -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force -ErrorAction SilentlyContinue | Out-Null
            Set-ItemProperty -Path $profileKey -Name "SystemResponsiveness" -Value 20 -Type DWord -Force -ErrorAction SilentlyContinue | Out-Null
            $interfacesKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
            $interfaces = Get-ChildItem -Path $interfacesKey
            foreach ($iface in $interfaces) {
                Remove-ItemProperty -Path $iface.PSPath -Name "TcpAckFrequency", "TcpNoDelay" -ErrorAction SilentlyContinue | Out-Null
            }
        }
        elseif ($category -eq "Visuals") {
            $visualKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
            Set-ItemProperty -Path $visualKey -Name "VisualFXSetting" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue | Out-Null
        }
        elseif ($category -eq "Telemetry") {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue | Out-Null
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue | Out-Null
            Set-Service -Name DiagTrack -StartupType Automatic -ErrorAction SilentlyContinue
        }
        elseif ($category -eq "Xbox") {
            Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -ErrorAction SilentlyContinue | Out-Null
            Remove-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -ErrorAction SilentlyContinue | Out-Null
            Set-Service -Name XblAuthManager -StartupType Manual -ErrorAction SilentlyContinue
            Set-Service -Name XblGameSave -StartupType Manual -ErrorAction SilentlyContinue
            Set-Service -Name XboxNetApiSvc -StartupType Manual -ErrorAction SilentlyContinue
        }
        Write-Host "  [-] Category $category set to defaults." -ForegroundColor Green
        return
    }

    $backup = Load-Backup
    Write-Host "  [-] Reverting $category from backup..." -ForegroundColor Yellow

    if ($category -eq "Services") {
        $services = @("Spooler", "Fax", "SysMain", "WerSvc")
        foreach ($svcName in $services) {
            if ($backup.Services -and $backup.Services.PSObject.Properties[$svcName]) {
                $startType = $backup.Services.$svcName
                try {
                    Set-Service -Name $svcName -StartupType $startType -ErrorAction Stop
                    if ($startType -eq "Automatic") { Start-Service -Name $svcName -ErrorAction SilentlyContinue | Out-Null }
                    Write-Host ($txt.MsgRestoreService -f $svcName, $startType) -ForegroundColor Green
                } catch {}
            }
        }
    }
    elseif ($category -eq "Network") {
        $profileKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        foreach ($name in @("NetworkThrottlingIndex", "SystemResponsiveness")) {
            $fullKey = "$profileKey\$name"
            if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey]) {
                $val = $backup.Registry.$fullKey
                try {
                    if ($null -eq $val) {
                        Remove-ItemProperty -Path $profileKey -Name $name -ErrorAction SilentlyContinue | Out-Null
                    } else {
                        Set-ItemProperty -Path $profileKey -Name $name -Value $val -Type DWord -Force | Out-Null
                    }
                } catch {}
            }
        }
        $interfacesKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
        $interfaces = Get-ChildItem -Path $interfacesKey
        foreach ($iface in $interfaces) {
            $path = $iface.PSPath
            foreach ($name in @("TcpAckFrequency", "TcpNoDelay")) {
                $fullKey = "$path\$name"
                if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey]) {
                    $val = $backup.Registry.$fullKey
                    try {
                        if ($null -eq $val) {
                            Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Out-Null
                        } else {
                            Set-ItemProperty -Path $path -Name $name -Value $val -Type DWord -Force | Out-Null
                        }
                    } catch {}
                } else {
                    Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Out-Null
                }
            }
        }
        Write-Host "  [-] Network & Latency configuration restored" -ForegroundColor Green
    }
    elseif ($category -eq "Visuals") {
        $visualKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
        $fullKey = "$visualKey\VisualFXSetting"
        if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey]) {
            $val = $backup.Registry.$fullKey
            try {
                if ($null -eq $val) {
                    Remove-ItemProperty -Path $visualKey -Name "VisualFXSetting" -ErrorAction SilentlyContinue | Out-Null
                } else {
                    Set-ItemProperty -Path $visualKey -Name "VisualFXSetting" -Value $val -Type DWord -Force | Out-Null
                }
                Write-Host "  [-] Visual FX settings restored" -ForegroundColor Green
            } catch {}
        }
        if ($backup.PowerScheme) {
            try {
                powercfg /setactive $backup.PowerScheme | Out-Null
                Write-Host "  [-] Active Power Plan restored" -ForegroundColor Green
            } catch {}
        }
    }
    elseif ($category -eq "Telemetry") {
        $policyKey1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $fullKey1 = "$policyKey1\AllowTelemetry"
        if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey1]) {
            $val = $backup.Registry.$fullKey1
            try {
                if ($null -eq $val) { Remove-ItemProperty -Path $policyKey1 -Name "AllowTelemetry" -ErrorAction SilentlyContinue | Out-Null }
                else { Set-ItemProperty -Path $policyKey1 -Name "AllowTelemetry" -Value $val -Type DWord -Force | Out-Null }
            } catch {}
        }
        $policyKey2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $fullKey2 = "$policyKey2\AllowTelemetry"
        if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey2]) {
            $val = $backup.Registry.$fullKey2
            try {
                if ($null -eq $val) { Remove-ItemProperty -Path $policyKey2 -Name "AllowTelemetry" -ErrorAction SilentlyContinue | Out-Null }
                else { Set-ItemProperty -Path $policyKey2 -Name "AllowTelemetry" -Value $val -Type DWord -Force | Out-Null }
            } catch {}
        }
        if ($backup.Services -and $backup.Services.PSObject.Properties["DiagTrack"]) {
            $startType = $backup.Services.DiagTrack
            try {
                Set-Service -Name "DiagTrack" -StartupType $startType
                if ($startType -eq "Automatic") { Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue | Out-Null }
                Write-Host ($txt.MsgRestoreService -f "DiagTrack", $startType) -ForegroundColor Green
            } catch {}
        }
    }
    elseif ($category -eq "Xbox") {
        $dvrKey1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
        $fullKey1 = "$dvrKey1\AppCaptureEnabled"
        if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey1]) {
            $val = $backup.Registry.$fullKey1
            try {
                if ($null -eq $val) { Remove-ItemProperty -Path $dvrKey1 -Name "AppCaptureEnabled" -ErrorAction SilentlyContinue | Out-Null }
                else { Set-ItemProperty -Path $dvrKey1 -Name "AppCaptureEnabled" -Value $val -Type DWord -Force | Out-Null }
            } catch {}
        }
        $dvrKey2 = "HKCU:\System\GameConfigStore"
        $fullKey2 = "$dvrKey2\GameDVR_Enabled"
        if ($backup.Registry -and $backup.Registry.PSObject.Properties[$fullKey2]) {
            $val = $backup.Registry.$fullKey2
            try {
                if ($null -eq $val) { Remove-ItemProperty -Path $dvrKey2 -Name "GameDVR_Enabled" -ErrorAction SilentlyContinue | Out-Null }
                else { Set-ItemProperty -Path $dvrKey2 -Name "GameDVR_Enabled" -Value $val -Type DWord -Force | Out-Null }
            } catch {}
        }
        $xboxServices = @("XblAuthManager", "XblGameSave", "XboxNetApiSvc")
        foreach ($svcName in $xboxServices) {
            if ($backup.Services -and $backup.Services.PSObject.Properties[$svcName]) {
                $startType = $backup.Services.$svcName
                try {
                    Set-Service -Name $svcName -StartupType $startType
                    if ($startType -eq "Automatic") { Start-Service -Name $svcName -ErrorAction SilentlyContinue | Out-Null }
                    Write-Host ($txt.MsgRestoreService -f $svcName, $startType) -ForegroundColor Green
                } catch {}
            }
        }
    }

    Save-Backup $backup
}

function Show-TweaksMenu() {
    if (-not (Test-IsAdmin)) {
        Clear-Host
        Write-Host ""
        Write-Host $txt.MsgAdminRequired -ForegroundColor Yellow
        Write-Host ""
        $answer = (Read-Host "  $($txt.MsgAdminConfirmPrompt)").Trim().ToLower()
        if ($answer -in @("y", "s", "yes", "sim", "o", "oui", "ja")) {
            Relaunch-AsAdmin "tweaks"
        }
        return
    }

    while ($true) {
        Clear-Host

        $statusServices = Get-TweakStatus-Services
        $statusNetwork = Get-TweakStatus-Network
        $statusVisuals = Get-TweakStatus-Visuals
        $statusTelemetry = Get-TweakStatus-Telemetry
        $statusXbox = Get-TweakStatus-Xbox

        $labelServices = if ($statusServices -eq "Optimized") { $txt.TweakStatusOptimized } else { $txt.TweakStatusDefault }
        $labelNetwork  = if ($statusNetwork -eq "Optimized")  { $txt.TweakStatusOptimized } else { $txt.TweakStatusDefault }
        $labelVisuals  = if ($statusVisuals -eq "Optimized")  { $txt.TweakStatusOptimized } else { $txt.TweakStatusDefault }
        $labelTelemetry = if ($statusTelemetry -eq "Optimized") { $txt.TweakStatusOptimized } else { $txt.TweakStatusDefault }
        $labelXbox     = if ($statusXbox -eq "Optimized")     { $txt.TweakStatusOptimized } else { $txt.TweakStatusDefault }

        $colorServices = if ($statusServices -eq "Optimized") { "Green" } else { "DarkGray" }
        $colorNetwork  = if ($statusNetwork -eq "Optimized")  { "Green" } else { "DarkGray" }
        $colorVisuals  = if ($statusVisuals -eq "Optimized")  { "Green" } else { "DarkGray" }
        $colorTelemetry = if ($statusTelemetry -eq "Optimized") { "Green" } else { "DarkGray" }
        $colorXbox     = if ($statusXbox -eq "Optimized")     { "Green" } else { "DarkGray" }

        Write-Host ""
        Write-Host "  =====================================================" -ForegroundColor Cyan
        Write-Host "    $($txt.TweaksTitle)" -ForegroundColor Cyan
        Write-Host "  =====================================================" -ForegroundColor Cyan
        Write-Host ""

        Write-Host "  [1] $($txt.TweakCatServices.PadRight(56)) [" -NoNewline
        Write-Host $labelServices -NoNewline -ForegroundColor $colorServices
        Write-Host "]"

        Write-Host "  [2] $($txt.TweakCatNetwork.PadRight(56)) [" -NoNewline
        Write-Host $labelNetwork -NoNewline -ForegroundColor $colorNetwork
        Write-Host "]"

        Write-Host "  [3] $($txt.TweakCatVisuals.PadRight(56)) [" -NoNewline
        Write-Host $labelVisuals -NoNewline -ForegroundColor $colorVisuals
        Write-Host "]"

        Write-Host "  [4] $($txt.TweakCatTelemetry.PadRight(56)) [" -NoNewline
        Write-Host $labelTelemetry -NoNewline -ForegroundColor $colorTelemetry
        Write-Host "]"

        Write-Host "  [5] $($txt.TweakCatXbox.PadRight(56)) [" -NoNewline
        Write-Host $labelXbox -NoNewline -ForegroundColor $colorXbox
        Write-Host "]"

        Write-Host ""
        Write-Host ("  " + [string]::new('-', 68)) -ForegroundColor DarkGray
        Write-Host "  $($txt.TweakCommandsHeader)" -ForegroundColor DarkGray
        Write-Host "    1-5             $($txt.TweakCmdToggleDesc)" -ForegroundColor DarkGray
        Write-Host "    apply / tweak   $($txt.TweakCmdApplyDesc)" -ForegroundColor DarkGray
        Write-Host "    restore / undo  $($txt.TweakCmdRestoreDesc)" -ForegroundColor DarkGray
        Write-Host "    back / quit     $($txt.TweakCmdBackDesc)" -ForegroundColor DarkGray
        Write-Host ""

        $tweakInput = (Read-Host "  >>").Trim().ToLower()

        if ($tweakInput -in @("back", "quit", "sair", "voltar", "esci", "beenden", "quitter")) {
            break
        }

        if ($tweakInput -in @("restore", "undo", "restaurar", "reverter", "desfazer", "ripristina", "wiederherstellen")) {
            Restore-Tweaks
            continue
        }

        if ($tweakInput -in @("apply", "tweak", "aplicar", "otimizar", "ottimizza", "anwenden", "appliquer")) {
            Write-Host ""
            Write-Host "  Applying selected gaming tweaks..." -ForegroundColor Cyan
            Write-Host ("  " + [string]::new('-', 50)) -ForegroundColor DarkGray
            Apply-Tweak-Services
            Apply-Tweak-Network
            Apply-Tweak-Visuals
            Apply-Tweak-Telemetry
            Apply-Tweak-Xbox
            Write-Host ""
            Write-Host $txt.MsgTweaksApplied -ForegroundColor Green
            Read-Host $txt.PressEnter
            continue
        }

        if ($tweakInput -match "^[1-5]$") {
            Write-Host ""
            Write-Host "  Modifying selection..." -ForegroundColor Cyan
            Write-Host ("  " + [string]::new('-', 50)) -ForegroundColor DarkGray
            
            if ($tweakInput -eq "1") {
                if ($statusServices -eq "Optimized") { Restore-Category "Services" } else { Apply-Tweak-Services }
            }
            elseif ($tweakInput -eq "2") {
                if ($statusNetwork -eq "Optimized") { Restore-Category "Network" } else { Apply-Tweak-Network }
            }
            elseif ($tweakInput -eq "3") {
                if ($statusVisuals -eq "Optimized") { Restore-Category "Visuals" } else { Apply-Tweak-Visuals }
            }
            elseif ($tweakInput -eq "4") {
                if ($statusTelemetry -eq "Optimized") { Restore-Category "Telemetry" } else { Apply-Tweak-Telemetry }
            }
            elseif ($tweakInput -eq "5") {
                if ($statusXbox -eq "Optimized") { Restore-Category "Xbox" } else { Apply-Tweak-Xbox }
            }
            
            Read-Host $txt.PressEnter
        }
    }
}

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

    $cmdTweaksKey = $txt.CommandKeywords.Tweaks

    Write-Host "  $($txt.CommandsHeader)" -ForegroundColor DarkGray
    Write-Host "    1 / 1,3,5       $($txt.CmdToggle)" -ForegroundColor DarkGray
    Write-Host "    $cmdRecKey / apply     $($txt.CmdRecApply -f $pendingRecommendedCount)" -ForegroundColor DarkGray
    Write-Host "    $cmdSearchKey <text>   $($txt.CmdSearch)" -ForegroundColor DarkGray
    Write-Host "    $cmdTweaksKey          $($txt.CmdTweaksDesc)" -ForegroundColor DarkGray
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
    $cmdTweaks = @("tweaks", "tweak", $cmdTweaksKey) | Select-Object -Unique

    if ($commandInput -in $cmdQuit) { break }

    if ($commandInput -in $cmdTweaks) {
        Show-TweaksMenu
        continue
    }

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



