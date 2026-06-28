# Windows GPU Preference Manager

> Script PowerShell interativo para configurar preferencia de GPU por app no Windows 10 e Windows 11.

Windows GPU Preference Manager, tambem distribuido como `SmartGraphicsPreference`, ajuda a escolher quais aplicativos devem usar a GPU de alto desempenho no Windows. Ele automatiza o caminho manual de Configuracoes > Sistema > Video > Configuracoes de elementos graficos e funciona direto no terminal, sem instalador e sem dependencia obrigatoria.

Descricao curta para GitHub: `Script PowerShell interativo para configurar preferencia de GPU por app no Windows`

Topics recomendadas: `powershell`, `windows`, `gpu`, `windows10`, `windows11`

## Por Que Existe

No Windows, a preferencia de GPU por aplicativo fica escondida nas configuracoes graficas do sistema. Para quem usa notebook com GPU integrada e dedicada, ou alterna entre apps como navegador, Discord, OBS, VLC, Blender, editores e jogos, fazer isso manualmente e lento.

Este projeto lista os apps em execucao, destaca os que costumam se beneficiar da GPU dedicada e aplica a preferencia de alto desempenho no registro do usuario atual.

## Recursos

- Detecta automaticamente aplicativos em execucao com caminho valido
- Filtra processos de sistema e ruido comum do Windows
- Recomenda apps conhecidos que costumam usar aceleracao grafica
- Mostra uso de GPU em tempo real quando os contadores do Windows estao disponiveis
- Aplica alto desempenho em um app, varios apps ou todos os recomendados
- Permite buscar por nome de app direto no terminal
- Usa toggle para remover a preferencia e voltar ao padrao do sistema
- Roda com PowerShell 5.1+ no Windows 10 e Windows 11

## Casos De Uso

- Forcar navegador, player de video ou app de streaming a usar GPU dedicada
- Ajustar Discord, OBS, VLC, Blender, editores e launchers de jogos com menos cliques
- Conferir quais apps estao usando GPU no momento
- Compartilhar uma ferramenta simples para usuarios Windows sem instalar um app pesado

## Estrutura

```text
Windows-GPU-Preference-Manager/
|-- SmartGraphicsPreference.ps1   # Script principal
|-- SmartGPU.bat                  # Launcher para duplo clique
|-- build/
|   `-- build.ps1                 # Gera .exe com ps2exe
|-- README.md
|-- LICENSE
`-- .gitignore
```

## Como Usar

### Requisitos

- Windows 10 ou Windows 11
- PowerShell 5.1 ou superior
- GPU dedicada, como NVIDIA, AMD Radeon ou Intel Arc, quando quiser usar alto desempenho

### Rodar Pelo PowerShell

```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1"
```

### Rodar Por Duplo Clique

Execute `SmartGPU.bat` na mesma pasta do `SmartGraphicsPreference.ps1`.

## Interface

```text
  =====================================================
    Preferencia Grafica Inteligente   [Alto Desempenho]
  =====================================================

  #    App                        Categoria    GPU%   Status
  ----------------------------------------------------------------
  1    chrome                     Navegador    12%    [OK] Alto Desempenho
  2    discord                    Comunicacao   2%    [RECOMENDADO]
  3    vlc                        Video         0%
  4    obs64                      Streaming     8%    [RECOMENDADO]

  Comandos:
    1 / 1,3,5    Ativar ou remover (toggle)
    rec          Aplicar TODOS os recomendados (2 pendentes)
    busca <x>    Filtrar lista (ex: busca discord)
    todos        Limpar filtro
    sair         Fechar
```

## Comandos

| Comando | Acao |
|---|---|
| `1` | Ativa ou remove a preferencia do app numero 1 |
| `1,3,5` | Ativa ou remove varios apps de uma vez |
| `rec` | Aplica alto desempenho em todos os recomendados pendentes |
| `busca discord` | Filtra a lista por nome |
| `todos` | Limpa o filtro atual |
| `sair` | Fecha o script |

Depois de alterar a preferencia de GPU, reinicie os aplicativos afetados para garantir que o Windows aplique a mudanca.

## Gerar Executavel

O executavel e opcional. O script PowerShell funciona sozinho.

```powershell
PowerShell -ExecutionPolicy Bypass -File "build\build.ps1"
```

O build usa o modulo `ps2exe`. Se ele nao estiver instalado, o script tenta instalar automaticamente para o usuario atual.

## Como Funciona

O script grava preferencias em:

```text
HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences
```

Ele usa `GpuPreference=2` para alto desempenho, que e o mesmo tipo de configuracao feita pela tela de configuracoes graficas do Windows. A alteracao vale para o usuario atual.

## Palavras-Chave

PowerShell, Windows, Windows 10, Windows 11, GPU, dedicated GPU, integrated GPU, NVIDIA, AMD Radeon, Intel Arc, graphics settings, GPU preference, per-app GPU preference, UserGpuPreferences, alto desempenho, preferencia grafica.

## Contribuir

A forma mais simples de contribuir e adicionar apps conhecidos ao dicionario `$appsDB` em `SmartGraphicsPreference.ps1`.

```powershell
$appsDB = @{
    "meuapp" = @{ Cat = "Video"; Rec = $true }
}
```

Use `Rec = $true` para apps que normalmente se beneficiam de GPU dedicada. Use `Rec = $false` para apps que devem aparecer categorizados, mas sem recomendacao automatica.

## Licenca

MIT. Veja `LICENSE`.
