# 🚀 Windows GPU Preference Manager

[![License](https://img.shields.io/badge/Licen%C3%A7a-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Plataforma-Windows%2010%20%7C%2011-0078d6.svg)](https://www.microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Languages](https://img.shields.io/badge/Idiomas-Multil%C3%ADngue%20(8%20idiomas)-orange.svg)](#-suporte-a-idiomas)

Utilitário PowerShell interativo e leve para gerenciar preferências de GPU por aplicativo no Windows 10 e Windows 11. Ele automatiza a tediosa configuração manual encontrada em *Configurações > Sistema > Tela > Elementos Gráficos* e roda instantaneamente direto no terminal, sem necessidade de instalação.

---

## 🌎 Idiomas / Languages

* [Read in English](README.md)
* [Leia em Português](README.pt-BR.md)

---

## 💡 Por que usar?

No Windows, alterar a preferência de GPU (GPU Integrada vs. Dedicada de Alto Desempenho) para aplicativos individuais exige cliques em várias camadas das configurações do sistema, navegação por pastas e seleção manual de executáveis. Se você usa um notebook gamer, desktop com duas GPUs ou costuma alterar as preferências de navegadores, players de mídia, ferramentas de streaming, launchers de jogos e programas de modelagem 3D, fazer isso um a um é lento e repetitivo.

O **Windows GPU Preference Manager** resolve isso permitindo:
1. **Visualizar instantaneamente** os aplicativos ativos (não pertencentes ao sistema) e suas configurações atuais de GPU.
2. **Aplicar Alto Desempenho** a aplicativos específicos, múltiplos aplicativos ou recomendações em lote com um único comando.
3. **Monitorar a utilização da GPU em tempo real** para cada processo ativo diretamente no console.

---

## ✨ Recursos

* ⚡ **Descoberta Automática:** Lista automaticamente os aplicativos do usuário atualmente em execução com um caminho executável válido.
* 🛡️ **Filtro de Sistema:** Exclui ruídos de fundo e processos padrão do sistema Windows automaticamente.
* 🌐 **Suporte Multilíngue:** Suporta **8 idiomas principais** (inglês, português, espanhol, francês, alemão, chinês, japonês e italiano) com detecção automática do idioma de exibição do SO e seleção manual ao iniciar.
* 📊 **Uso de GPU em Tempo Real:** Mostra a porcentagem de utilização do motor 3D da GPU por aplicativo em execução quando os contadores de desempenho do Windows estão ativos.
* 🎯 **Recomendações Inteligentes:** Destaca automaticamente aplicativos que comumente se beneficiam de uma GPU dedicada (ex: Chrome, OBS, Discord, VLC, Steam, Blender, Photoshop, jogos).
* 🔄 **Fluxo Simples de Alternância:** Ative facilmente o modo de Alto Desempenho ou restaure os padrões do Windows (toggle).
* 🔍 **Filtro/Busca no Terminal:** Filtre itens da lista instantaneamente com o comando de busca (ex: `busca`).
* 📦 **Pronto para Compilar:** Inclui um script de compilação para empacotar o utilitário em um executável `.exe` independente usando `ps2exe`.

---

## 🛠️ Estrutura do Repositório

```text
Windows-GPU-Preference-Manager/
├── SmartGraphicsPreference.ps1   # Script PowerShell principal com suporte multilíngue
├── SmartGPU.bat                  # Launcher em lote (encaminha argumentos do console)
├── build/
│   └── build.ps1                 # Builder opcional de executável usando ps2exe
├── README.md                     # Documentação (Inglês)
├── README.pt-BR.md               # Documentação (Português)
├── LICENSE                       # Licença MIT
└── .gitignore                    # Exclusões de arquivos do Git
```

---

## 📋 Requisitos

* **Sistema Operacional:** Windows 10 ou Windows 11
* **Console:** Windows PowerShell 5.1 ou superior
* **Hardware:** Sistemas com GPUs duplas (gráficos integrados + dedicados, como NVIDIA GeForce/RTX, AMD Radeon, Intel Arc) para aproveitar a preferência de *Alto Desempenho* no registro.

---

## 🚀 Como Executar

### Opção 1: Duplo Clique (Recomendado)
Dê um duplo clique em `SmartGPU.bat` na pasta raiz. Ele ignora as políticas de execução do PowerShell automaticamente.

### Opção 2: Console PowerShell
Abra seu terminal e execute:
```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1"
```

Para forçar um idioma específico diretamente via linha de comando, passe o argumento `-Language`:
```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1" -Language pt
```
*(Códigos de idioma suportados: `en`, `pt`, `es`, `fr`, `de`, `zh`, `ja`, `it`)*

Para abrir o menu diretamente na tela de Otimizações de Jogos, passe o argumento `-Menu`:
```powershell
PowerShell -ExecutionPolicy Bypass -File "SmartGraphicsPreference.ps1" -Menu tweaks
```

---

## 🗺️ Suporte a Idiomas

Ao iniciar, a ferramenta detecta automaticamente o idioma de exibição do Windows e carrega as traduções correspondentes. Ela também exibe um menu para seleção manual:

```text
  Select language / Selecione o idioma / Seleccione el idioma:
  ===========================================================
    [1] English       [2] Português      [3] Español
    [4] Français      [5] Deutsch        [6] 简体中文
    [7] 日本語        [8] Italiano

  Press Enter to auto-detect (Default: Português)

  Language [1-8]: 
```

---

## 🖥️ Exemplo de Interface no Terminal

```text
  =====================================================
    Gerenciador de Preferência de GPU   [Alto Desempenho]
  =====================================================

  #    App                        Categoria      GPU%   Status
  ----------------------------------------------------------------
  1    chrome                     Navegador      12%    [OK] Alto Desempenho
  2    discord                    Comunicação    2%     [RECOMENDADO]
  3    vlc                        Vídeo          0%     
  4    obs64                      Streaming      8%     [RECOMENDADO]
  5    blender                    3D             0%     [OK] Alto Desempenho

  ----------------------------------------------------------------
  Comandos:
    1 / 1,3,5       Alternar preferência de alto desempenho
    rec / aplicar   Aplicar todos os recomendados (2 pendentes)
    busca <texto>   Filtrar lista
    todos           Limpar filtro
    sair            Fechar

  Resumo: 2 configurado(s), 2 recomendado(s) pendente(s)
  Filtro: ''

  > 
```

---

## 🕹️ Referência de Comandos

| Comando (PT) | Ação |
|---|---|
| `1` | Alterna (adiciona ou remove) a preferência de Alto Desempenho para o aplicativo de número 1. |
| `1,3,5` | Alterna preferências para múltiplos aplicativos listados de uma vez (separados por vírgula). |
| `rec` / `aplicar` | Aplica automaticamente a preferência de Alto Desempenho para todos os recomendados pendentes. |
| `busca chrome` | Filtra a exibição da tabela para mostrar apenas processos contendo "chrome". |
| `ajustes` | Abre o menu de otimizações de jogos (Windows Gaming Tweaks). |
| `todos` | Redefine a lista e limpa qualquer filtro de busca ativo. |
| `sair` | Fecha o utilitário com segurança. |

> [!NOTE]
> Após alterar as preferências, reinicie os aplicativos afetados para que o Windows passe a usar a GPU configurada.

---

## 🛠️ Otimizações de Desempenho de Jogos do Windows

O menu de otimizações oferece acesso a 5 categorias de melhorias no sistema:
1. **Ajuste de Serviços:** Desativa serviços secundários em segundo plano (Print Spooler, Fax, SysMain/Superfetch, Windows Error Reporting).
2. **Rede e Latência:** Desativa o algoritmo Nagle (TCP No Delay e TCP Ack Frequency) nos adaptadores ativos, prioriza a responsividade de rede para jogos e desativa a limitação de tráfego (Network Throttling).
3. **Visual e Energia:** Otimiza os efeitos visuais para melhor desempenho e ativa o plano de energia de "Desempenho Máximo" (Ultimate Performance).
4. **Telemetria e Privacidade:** Desativa as políticas de coleta de dados de telemetria e o serviço de rastreamento de diagnósticos.
5. **Serviços Xbox e DVR:** Desativa a sobreposição de captura Game DVR e os serviços em segundo plano do Xbox Live.

> [!IMPORTANT]
> - A aplicação dessas melhorias requer privilégios de Administrador. Se executado no modo padrão, o script solicitará permissão e reiniciará automaticamente em uma janela elevada.
> - Antes de qualquer modificação, a ferramenta cria um backup dinâmico `.sgp-backup.json` na pasta do script. Você pode reverter todas as otimizações para os valores originais do seu sistema a qualquer momento usando o comando `restaurar` ou `desfazer` dentro do próprio menu de otimizações.

---

## ⚙️ Compilação (Executável Opcional .exe)

Para gerar um arquivo executável `.exe` autônomo para rodar o utilitário sem precisar abrir o PowerShell explicitamente:
```powershell
PowerShell -ExecutionPolicy Bypass -File "build\build.ps1"
```
O script de compilação utiliza o módulo `ps2exe`. Se ele não for encontrado, o script tentará instalá-lo no escopo do usuário atual antes de criar o arquivo `SmartGraphicsPreference.exe`.

---

## 🔍 Como Funciona Internamente

Por baixo dos panos, o Windows armazena preferências gráficas por aplicativo na chave de registro do usuário atual:
```text
HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences
```
O script grava o caminho absoluto do executável como o nome da propriedade e atribui a string:
* `GpuPreference=2;` — Configura o aplicativo para usar **Alto Desempenho** (GPU dedicada).
* Remover a propriedade do registro redefine o aplicativo para o **Padrão do Windows**.

---

## 🏷️ Otimização de Busca no GitHub (SEO)

Para otimizar este repositório para descoberta no GitHub, aplique os seguintes **Tópicos (Topics)** nas configurações do seu repositório:

`powershell` · `windows-utility` · `gpu-preference` · `nvidia` · `amd-radeon` · `graphics-preference` · `high-performance` · `performance-tuning` · `gaming-optimization` · `windows11` · `windows10` · `windows-11` · `windows-10` · `gpu-monitor` · `low-overhead` · `multilingual`

---

## 🤝 Contribuição

Contribuições são super bem-vindas! Se você quiser expandir a base de recomendações inteligentes, basta adicionar novas entradas à tabela hash `$appDatabase` no arquivo [SmartGraphicsPreference.ps1](file:///c:/Users/User/Desktop/SmartGPU/claude_analisar/SmartGraphicsPreference.ps1):

```powershell
"novoapp" = @{ Category = "Games"; Recommended = $true }
```
- `Category`: Escolha uma categoria correspondente (Browser, Video, 3D, Design, Video Edit, Streaming, Games, Communication, Developer, Other).
- `Recommended`: Defina como `$true` para aplicativos que devem ser sinalizados como recomendados para GPU dedicada, ou `$false` apenas para categorização.

---

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE).
