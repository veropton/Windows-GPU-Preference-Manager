# SmartGraphicsPreference

> Script PowerShell interativo para configurar a preferência de GPU por aplicativo no Windows — zero config, com monitor de uso de GPU em tempo real e recomendações automáticas.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Como Usar](#como-usar)
- [Compilar para .exe](#compilar-para-exe)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)

---

## Visão Geral

O Windows permite definir manualmente qual GPU cada aplicativo deve usar (integrada ou dedicada) em **Configurações → Sistema → Vídeo → Configurações de Elementos Gráficos**. Fazer isso manualmente é lento. Este script automatiza o processo com uma interface interativa no terminal.

---

## Funcionalidades

- **Zero configuração** — detecta automaticamente todos os processos em execução
- **Filtro de ruído** — oculta processos de sistema irrelevantes (svchost, conhost, etc.)
- **Base de conhecimento** — identifica e categoriza +40 apps conhecidos (navegadores, games, editores, streaming)
- **Recomendações automáticas** — apps GPU-intensivos aparecem destacados como `[RECOMENDADO]`
- **Monitor de GPU em tempo real** — exibe o uso real de GPU (%) por processo via contadores do Windows
- **Aplicação em lote** — comando `rec` configura todos os recomendados de uma vez
- **Busca/filtro** — filtra a lista digitando parte do nome do app
- **Toggle** — digitar o número de um app já configurado o remove (reverte ao padrão)

---

## Estrutura do Repositório

```
SmartGraphicsPreference/
├── SmartGraphicsPreference.ps1   # Script principal
├── SmartGPU.bat                  # Launcher (duplo clique para rodar)
├── build/
│   └── build.ps1                 # Compila o script para .exe com ps2exe
├── README.md
└── LICENSE
```

---

## Como Usar

### Pré-requisitos

- Windows 10 ou 11
- PowerShell 5.1+ (já incluso no Windows)
- GPU dedicada (NVIDIA, AMD ou Intel Arc)

### Opção 1 — Direto pelo PowerShell

```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1"
```

### Opção 2 — Duplo clique (sem abrir o PowerShell)

Execute o arquivo `SmartGPU.bat`. O `.ps1` deve estar na mesma pasta.

### Interface

```
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

### Comandos disponíveis

| Comando | Descrição |
|---|---|
| `1` | Ativa ou remove o app de número 1 (toggle) |
| `1,3,5` | Ativa/remove múltiplos apps de uma vez |
| `rec` | Aplica Alto Desempenho em todos os apps recomendados pendentes |
| `busca discord` | Filtra a lista mostrando apenas apps com "discord" no nome |
| `todos` | Limpa o filtro atual e mostra todos |
| `sair` | Encerra o script |

> **Nota:** Reinicie os aplicativos alterados para que as mudanças entrem em vigor.

---

## Compilar para .exe

Para gerar um executável standalone (não precisa do `.ps1` junto):

```powershell
# Execute o script de build (instala ps2exe automaticamente se necessário)
PowerShell -ExecutionPolicy Bypass -File "build\build.ps1"
```

O arquivo `SmartGraphicsPreference.exe` será gerado na pasta raiz.

#### Requisitos do build

- PowerShell com acesso à internet (para baixar o módulo `ps2exe` caso não esteja instalado)
- Ou instale manualmente: `Install-Module -Name ps2exe -Scope CurrentUser -Force`

---

## Como Contribuir

Contribuições são bem-vindas! As formas mais úteis são:

### Adicionar apps à base de conhecimento

Edite o dicionário `$appsDB` no início do `SmartGraphicsPreference.ps1`:

```powershell
$appsDB = @{
    # Formato: "nome_do_processo" = @{ Cat = "Categoria"; Rec = $true/$false }
    "meuapp" = @{ Cat = "Video"; Rec = $true }
    ...
}
```

- `Rec = $true` → aparece como `[RECOMENDADO]` (use para apps GPU-intensivos)
- `Rec = $false` → aparece na lista mas sem destaque

O nome do processo é o que aparece no Gerenciador de Tarefas, sem `.exe`, em minúsculas.

### Reportar bugs ou sugerir melhorias

Abra uma [Issue](../../issues) descrevendo o problema ou a sugestão.

### Pull Requests

1. Faça um fork do repositório
2. Crie uma branch: `git checkout -b minha-melhoria`
3. Faça as alterações e commit: `git commit -m "feat: adiciona suporte ao app X"`
4. Envie: `git push origin minha-melhoria`
5. Abra um Pull Request

---

## Licença

MIT © [seu nome]
