<div align="center">
  <br>
  <h1>Godot ReGit 🚀</h1>
  <p><b>A Máquina Perfeita de Controle de Versão (Git) para Godot 4</b></p>
</div>

O **Godot ReGit** é um plugin definitivo de Git construído do zero para se integrar perfeitamente à interface e ao ecossistema da Godot 4. Pare de alternar entre o editor e o terminal. Tenha o poder completo do versionamento de código no seu painel inferior, com a elegância nativa que o seu projeto merece.

---

## ✨ Características Principais

* 🎨 **100% UI Nativa e Integrada:** Não parece uma gambiarra de terceiros. Utilizamos iconografia oficial e esquemas de cores do editor da Godot para que o plugin pareça construído pela própria comunidade core.
* 🔎 **Abas Dinâmicas de Diff Visual:** Dê um duplo-clique em qualquer arquivo modificado e uma **Nova Aba** será aberta dinamicamente no seu painel inferior (ao lado de Saída/Depurador) mostrando exatamente as linhas adicionadas (🟢) e removidas (🔴), estilo VS Code.
* ☁️ **Gerenciador de Nuvem (GitHub):** Crie novos repositórios na nuvem, conecte, sincronize, dê pull, push e delete branches inteiras diretamente de dentro da engine, utilizando seu Personal Access Token.
* ⚡ **Auto-Refresh Inteligente:** O plugin sente o seu olhar. Ele usa o evento `NOTIFICATION_APPLICATION_FOCUS_IN` para atualizar instantaneamente a lista de arquivos modificados quando você volta para o editor.
* ⏪ **O "Botão de Pânico":** Estragou um script? Selecione-o na lista e clique em "Reverter Selecionado" para que ele volte magicamente ao estado seguro do último commit.
* 🌍 **Localização Inteligente:** Se comunica com a `EditorInterface` para identificar a linguagem do seu editor Godot. 100% de suporte para Inglês (EN), Português (PT) e Espanhol (ES) de forma automática.
* 🛡️ **Blindagem Anti-Erros:** Teste inteligente ao iniciar. Se a máquina não possuir o Git instalado, uma tela didática e amigável direciona o desenvolvedor (ou membro da equipe) para a página de instalação.

## 🚀 Como Usar

1. Copie a pasta `addons/gd_git_cli` para dentro da pasta `addons/` do seu projeto Godot 4.
2. Acesse `Projeto > Configurações do Projeto > Plugins` e ative o plugin.
3. O painel **Git CLI** aparecerá no dock inferior do seu editor.
4. Para a conexão com a nuvem, vá nas configurações de desenvolvedor da sua conta GitHub e gere um **Personal Access Token (classic)** com permissões de `repo` e `delete_repo`.

---
<p align="center"><i>Feito com poder, velocidade e elegância para desenvolvedores Godot.</i></p>
