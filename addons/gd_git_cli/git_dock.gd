@tool
extends Control

signal open_diff(file_path: String, diff_bbcode: String)

@onready var github_request = $GitHubRequest

# Views
@onready var center_wrapper = $CenterWrapper
@onready var auth_view = $CenterWrapper/AuthView
@onready var repos_view = $CenterWrapper/ReposView
@onready var workspace_view = $WorkspaceView

# Auth nodes
@onready var init_button = $CenterWrapper/AuthView/Margin/VBox/InitButton
@onready var github_token = $CenterWrapper/AuthView/Margin/VBox/TokenBox/GitHubToken
@onready var fetch_button = $CenterWrapper/AuthView/Margin/VBox/TokenBox/FetchButton
@onready var loading_label = $CenterWrapper/AuthView/Margin/VBox/LoadingLabel

# Repos nodes
@onready var disconnect_token_button = $CenterWrapper/ReposView/Margin/VBox/Header/DisconnectTokenButton
@onready var repo_select = $CenterWrapper/ReposView/Margin/VBox/SelectBox/RepoSelect
@onready var connect_button = $CenterWrapper/ReposView/Margin/VBox/SelectBox/ConnectButton
@onready var delete_repo_button = $CenterWrapper/ReposView/Margin/VBox/SelectBox/DeleteRepoButton
@onready var new_github_repo_name = $CenterWrapper/ReposView/Margin/VBox/CreateBox/NewGitHubRepoName
@onready var create_github_repo_button = $CenterWrapper/ReposView/Margin/VBox/CreateBox/CreateGitHubRepoButton

# Workspace nodes
@onready var remote_info_label = $WorkspaceView/MainContainer/RepoHeader/RemoteInfoLabel
@onready var back_button = $WorkspaceView/MainContainer/RepoHeader/BackButton
@onready var branch_select = $WorkspaceView/MainContainer/BranchHeader/BranchSelect
@onready var delete_branch_button = $WorkspaceView/MainContainer/BranchHeader/DeleteBranchButton
@onready var new_branch_name = $WorkspaceView/MainContainer/BranchHeader/NewBranchName
@onready var create_branch_button = $WorkspaceView/MainContainer/BranchHeader/CreateBranchButton

@onready var status_list = $WorkspaceView/MainContainer/SplitLayout/LeftPanelCard/Margin/LeftPanel/StatusList
@onready var discard_button = $WorkspaceView/MainContainer/SplitLayout/LeftPanelCard/Margin/LeftPanel/DiscardButton
@onready var commit_message = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/CommitMessage
@onready var status_button = $WorkspaceView/MainContainer/SplitLayout/LeftPanelCard/Margin/LeftPanel/StatusHeader/StatusButton
@onready var commit_button = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/CommitButton
@onready var pull_button = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/ActionButtons/PullButton
@onready var push_button = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/ActionButtons/PushButton
@onready var history_button = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/ConsoleHeader/HistoryButton
@onready var output_console = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/OutputConsole

# Translations nodes
@onready var auth_title = $CenterWrapper/AuthView/Margin/VBox/Title
@onready var auth_remote_lbl = $CenterWrapper/AuthView/Margin/VBox/RemoteLabel
@onready var auth_token_help = $CenterWrapper/AuthView/Margin/VBox/TokenHelpLabel
@onready var repos_title = $CenterWrapper/ReposView/Margin/VBox/Header/Title
@onready var repos_select_lbl = $CenterWrapper/ReposView/Margin/VBox/SelectLabel
@onready var repos_create_lbl = $CenterWrapper/ReposView/Margin/VBox/CreateLabel
@onready var ws_branch_lbl = $WorkspaceView/MainContainer/BranchHeader/BranchLabel
@onready var ws_mod_files_lbl = $WorkspaceView/MainContainer/SplitLayout/LeftPanelCard/Margin/LeftPanel/StatusHeader/Label
@onready var ws_commit_hdr = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/CommitHeader
@onready var ws_sync_hdr = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/SyncHeader
@onready var ws_console_lbl = $WorkspaceView/MainContainer/SplitLayout/RightPanelCard/Margin/RightPanel/ConsoleHeader/ConsoleLabel
@onready var delete_branch_btn = $WorkspaceView/MainContainer/BranchHeader/DeleteBranchButton

@onready var error_view = $ErrorView
@onready var error_title = $ErrorView/VBox/ErrorTitle
@onready var error_desc = $ErrorView/VBox/ErrorDesc
@onready var error_link = $ErrorView/VBox/ErrorLink

var current_branches = []
var fetched_repos = []
var current_github_action = ""

var lang = "en"

var translations = {
	"en": {
		"auth_title": "GitHub Authentication",
		"init_btn": "1. Initialize Local Repository (git init)",
		"remote_lbl": "2. Connect to Cloud (Requires GitHub PAT):",
		"fetch_btn": "Fetch Repositories",
		"token_help": "[i]To generate a PAT: GitHub > Settings > Developer settings > Tokens (classic). Check 'repo' and 'delete_repo'.[/i]",
		"loading_fetching": "Fetching repositories...",
		"loading_creating": "Creating repository...",
		"loading_deleting": "Deleting repository...",
		"err_api": "API Error ({code})",
		"err_read": "Error reading response.",
		"err_req": "Error sending request.",
		"repos_title": "Manage Repositories",
		"logout_btn": "Sign Out",
		"select_repo_lbl": "My Cloud Repositories:",
		"connect_btn": "Connect",
		"create_repo_lbl": "Or Create New on GitHub:",
		"create_repo_btn": "Create Cloud Repo",
		"remote_info": "Remote: ",
		"back_btn": "Back",
		"branch_lbl": "Current Branch:",
		"create_branch_btn": "Create Branch",
		"mod_files_lbl": "Modified Files",
		"status_btn": "Refresh",
		"commit_lbl": "Commit",
		"commit_btn": "Commit (Auto-Stage)",
		"sync_lbl": "Sync Changes",
		"pull_btn": "Pull",
		"push_btn": "Push",
		"console_lbl": "Terminal Log:",
		"err_empty_commit": "Cannot commit with an empty message.",
		"msg_switch_branch": "Switching to branch: ",
		"err_empty_branch": "Cannot create a branch with an empty name.",
		"msg_create_branch": "Creating and switching to new branch: ",
		"success_gitignore": "Success: Auto-generated .gitignore for Godot 4.",
		"msg_pulling": "Pulling from remote origin/",
		"err_pull": "Failed to pull: ",
		"msg_pushing": "Pushing to remote origin/",
		"err_push": "Failed to push: ",
		"success_git": "Success: git ",
		"err_git": "Error: git ",
		"success_del_repo": "Repository deleted successfully.",
		"err_del_repo": "Failed to delete repository.",
		"msg_auto_stage": "Auto-staging all modified files...",
		"success_del_branch": "Branch deleted.",
		"err_del_branch": "Cannot delete current active branch.",
		"discard_btn": "Discard Selected",
		"history_btn": "View History",
		"success_discard": "Changes discarded for: ",
		"err_no_file": "No file selected.",
		"msg_clean_repo": "✨ No changes. Repository is clean!",
		"token_place": "Paste your Personal Access Token (ghp_...)",
		"repo_place": "Repository name (e.g. My-Game)",
		"commit_place": "Commit message (required)...",
		"branch_place": "New branch name...",
		"err_git_title": "Git Not Found",
		"err_git_desc": "To use this plugin, you must have Git installed on your system.",
		"err_git_link": "Download Git (https://git-scm.com/)"
	},
	"pt": {
		"auth_title": "Autenticação GitHub",
		"init_btn": "1. Inicializar Repositório Local (git init)",
		"remote_lbl": "2. Conectar à Nuvem (Requer GitHub PAT):",
		"fetch_btn": "Buscar Repositórios",
		"token_help": "[i]Para gerar o PAT: GitHub > Settings > Developer settings > Tokens (classic). Marque 'repo' e 'delete_repo'.[/i]",
		"loading_fetching": "Buscando repositórios...",
		"loading_creating": "Criando repositório...",
		"loading_deleting": "Deletando repositório...",
		"err_api": "Erro da API ({code})",
		"err_read": "Erro ao ler a resposta.",
		"err_req": "Erro ao enviar requisição.",
		"repos_title": "Gerenciar Repositórios",
		"logout_btn": "Sair da Conta",
		"select_repo_lbl": "Meus Repositórios na Nuvem:",
		"connect_btn": "Conectar",
		"create_repo_lbl": "Ou Criar um Novo no GitHub:",
		"create_repo_btn": "Criar Nuvem",
		"remote_info": "Remoto: ",
		"back_btn": "Voltar",
		"branch_lbl": "Branch Atual:",
		"create_branch_btn": "Criar Branch",
		"mod_files_lbl": "Arquivos Modificados",
		"status_btn": "Atualizar",
		"commit_lbl": "Commit",
		"commit_btn": "Fazer Commit (Auto-Stage)",
		"sync_lbl": "Sincronização",
		"pull_btn": "Pull",
		"push_btn": "Push",
		"console_lbl": "Terminal Log:",
		"err_empty_commit": "Não é possível fazer commit com uma mensagem vazia.",
		"msg_switch_branch": "Mudando para a branch: ",
		"err_empty_branch": "Não é possível criar uma branch sem nome.",
		"msg_create_branch": "Criando e mudando para a branch: ",
		"success_gitignore": "Sucesso: .gitignore gerado automaticamente para Godot 4.",
		"msg_pulling": "Puxando do repositório remoto origin/",
		"err_pull": "Falha ao dar pull: ",
		"msg_pushing": "Enviando para o repositório remoto origin/",
		"err_push": "Falha ao dar push: ",
		"success_git": "Sucesso: git ",
		"err_git": "Erro: git ",
		"success_del_repo": "Repositório apagado com sucesso.",
		"err_del_repo": "Falha ao apagar repositório.",
		"msg_auto_stage": "Adicionando todos os arquivos modificados (auto-stage)...",
		"success_del_branch": "Branch deletada.",
		"err_del_branch": "Não é possível deletar a branch ativa no momento.",
		"discard_btn": "Reverter Selecionado",
		"history_btn": "Ver Histórico",
		"success_discard": "Alterações revertidas em: ",
		"err_no_file": "Nenhum arquivo selecionado.",
		"msg_clean_repo": "✨ Nenhuma alteração. Repositório limpo!",
		"token_place": "Cole o seu Personal Access Token (ghp_...)",
		"repo_place": "Nome do repositório (ex: Meu-Jogo)",
		"commit_place": "Mensagem do commit (obrigatória)...",
		"branch_place": "Nome da nova branch...",
		"err_git_title": "Git Não Encontrado",
		"err_git_desc": "Para usar este plugin, você precisa ter o Git instalado no seu sistema.",
		"err_git_link": "Baixar Git (https://git-scm.com/)"
	},
	"es": {
		"auth_title": "Autenticación GitHub",
		"init_btn": "1. Inicializar Repositorio Local (git init)",
		"remote_lbl": "2. Conectar a la Nube (Requiere GitHub PAT):",
		"fetch_btn": "Buscar Repositorios",
		"token_help": "[i]Para generar PAT: GitHub > Settings > Developer settings > Tokens (classic). Marca 'repo' y 'delete_repo'.[/i]",
		"loading_fetching": "Buscando repositorios...",
		"loading_creating": "Creando repositorio...",
		"loading_deleting": "Borrando repositorio...",
		"err_api": "Error de API ({code})",
		"err_read": "Error al leer respuesta.",
		"err_req": "Error al enviar solicitud.",
		"repos_title": "Gestionar Repositorios",
		"logout_btn": "Cerrar Sesión",
		"select_repo_lbl": "Mis Repositorios en la Nube:",
		"connect_btn": "Conectar",
		"create_repo_lbl": "O Crear Nuevo en GitHub:",
		"create_repo_btn": "Crear Nube",
		"remote_info": "Remoto: ",
		"back_btn": "Volver",
		"branch_lbl": "Rama Actual:",
		"create_branch_btn": "Crear Rama",
		"mod_files_lbl": "Archivos Modificados",
		"status_btn": "Actualizar",
		"commit_lbl": "Commit",
		"commit_btn": "Hacer Commit (Auto-Stage)",
		"sync_lbl": "Sincronización",
		"pull_btn": "Pull",
		"push_btn": "Push",
		"console_lbl": "Registro del Terminal:",
		"err_empty_commit": "No se puede hacer commit con un mensaje vacío.",
		"msg_switch_branch": "Cambiando a la rama: ",
		"err_empty_branch": "No se puede crear una rama sin nombre.",
		"msg_create_branch": "Creando y cambiando a la rama: ",
		"success_gitignore": "Éxito: .gitignore autogenerado para Godot 4.",
		"msg_pulling": "Extrayendo del repositorio remoto origin/",
		"err_pull": "Fallo al hacer pull: ",
		"msg_pushing": "Enviando al repositorio remoto origin/",
		"err_push": "Fallo al hacer push: ",
		"success_git": "Éxito: git ",
		"err_git": "Error: git ",
		"success_del_repo": "Repositorio borrado con éxito.",
		"err_del_repo": "Fallo al borrar el repositorio.",
		"msg_auto_stage": "Agregando todos los archivos modificados (auto-stage)...",
		"success_del_branch": "Rama eliminada.",
		"err_del_branch": "No se puede eliminar la rama activa.",
		"discard_btn": "Revertir Selecionado",
		"history_btn": "Ver Historial",
		"success_discard": "Cambios revertidos en: ",
		"err_no_file": "Ningún archivo seleccionado.",
		"msg_clean_repo": "✨ Sin cambios. ¡Repositorio limpio!",
		"token_place": "Pega tu Personal Access Token (ghp_...)",
		"repo_place": "Nombre del repositorio (ej: Mi-Juego)",
		"commit_place": "Mensaje de commit (obligatorio)...",
		"branch_place": "Nombre de nueva rama...",
		"err_git_title": "Git No Encontrado",
		"err_git_desc": "Para usar este plugin, necesitas tener Git instalado en tu sistema.",
		"err_git_link": "Descargar Git (https://git-scm.com/)"
	}
}

func T(key: String) -> String:
	if translations.has(lang) and translations[lang].has(key):
		return translations[lang][key]
	if translations["en"].has(key):
		return translations["en"][key]
	return key

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		auto_refresh()

func _ready():
	_detect_language()
	_apply_translations()
	_apply_theme()
	
	var test_out = []
	var test_code = OS.execute("git", ["--version"], test_out, true, true)
	if test_code != 0:
		if center_wrapper: center_wrapper.hide()
		if workspace_view: workspace_view.hide()
		if error_view: error_view.show()
		return

	
	if init_button: init_button.pressed.connect(_on_init_pressed)
	if fetch_button: fetch_button.pressed.connect(_on_fetch_pressed)
	if connect_button: connect_button.pressed.connect(_on_connect_pressed)
	if create_github_repo_button: create_github_repo_button.pressed.connect(_on_create_github_repo_pressed)
	if delete_repo_button: delete_repo_button.pressed.connect(_on_delete_repo_pressed)
	if disconnect_token_button: disconnect_token_button.pressed.connect(_on_disconnect_token_pressed)
		
	if github_request: github_request.request_completed.connect(_on_github_request_completed)
		
	if back_button: back_button.pressed.connect(_on_back_pressed)
		
	if discard_button: discard_button.pressed.connect(_on_discard_pressed)
	if history_button: history_button.pressed.connect(_on_history_pressed)
	if status_list: status_list.item_activated.connect(_on_status_list_item_activated)
		
	if status_button: status_button.pressed.connect(_on_status_pressed)
	if commit_button: commit_button.pressed.connect(_on_commit_pressed)
	if pull_button: pull_button.pressed.connect(_on_pull_pressed)
	if push_button: push_button.pressed.connect(_on_push_pressed)
		
	if branch_select: branch_select.item_selected.connect(_on_branch_selected)
	if create_branch_button: create_branch_button.pressed.connect(_on_create_branch_pressed)
	if delete_branch_button:
		delete_branch_button.get_popup().id_pressed.connect(_on_delete_branch_id_pressed)
		
	_check_git_status()

func _detect_language():
	lang = "en"
	var sys_lang = ""
	
	if Engine.is_editor_hint():
		var settings = EditorInterface.get_editor_settings()
		if settings and settings.has_setting("interface/editor/editor_language"):
			sys_lang = settings.get_setting("interface/editor/editor_language")
			
	if sys_lang == "":
		sys_lang = OS.get_locale()
		
	if sys_lang.begins_with("pt"):
		lang = "pt"
	elif sys_lang.begins_with("es"):
		lang = "es"

func _apply_translations():
	if auth_title: auth_title.text = T("auth_title")
	if auth_remote_lbl: auth_remote_lbl.text = T("remote_lbl")
	if auth_token_help: auth_token_help.text = T("token_help")
	if init_button: init_button.text = T("init_btn")
	if fetch_button: fetch_button.text = T("fetch_btn")
	
	if repos_title: repos_title.text = T("repos_title")
	if repos_select_lbl: repos_select_lbl.text = T("select_repo_lbl")
	if repos_create_lbl: repos_create_lbl.text = T("create_repo_lbl")
	if disconnect_token_button: disconnect_token_button.text = T("logout_btn")
	if connect_button: connect_button.text = T("connect_btn")
	if create_github_repo_button: create_github_repo_button.text = T("create_repo_btn")
	
	if back_button: back_button.text = T("back_btn")
	if ws_branch_lbl: ws_branch_lbl.text = T("branch_lbl")
	if create_branch_button: create_branch_button.text = T("create_branch_btn")
	if ws_mod_files_lbl: ws_mod_files_lbl.text = T("mod_files_lbl")
	if discard_button: discard_button.text = T("discard_btn")
	if status_button: status_button.text = T("status_btn")
	if ws_commit_hdr: ws_commit_hdr.text = T("commit_lbl")
	if commit_button: commit_button.text = T("commit_btn")
	if ws_sync_hdr: ws_sync_hdr.text = T("sync_lbl")
	if pull_button: pull_button.text = T("pull_btn")
	if push_button: push_button.text = T("push_btn")
	if ws_console_lbl: ws_console_lbl.text = T("console_lbl")
	if history_button: history_button.text = T("history_btn")
	
	if github_token: github_token.placeholder_text = T("token_place")
	if new_github_repo_name: new_github_repo_name.placeholder_text = T("repo_place")
	if commit_message: commit_message.placeholder_text = T("commit_place")
	if new_branch_name: new_branch_name.placeholder_text = T("branch_place")
	
	if error_title: error_title.text = T("err_git_title")
	if error_desc: error_desc.text = T("err_git_desc")
	if error_link: error_link.text = T("err_git_link")

func _apply_theme():
	if not is_inside_tree(): return
	if status_button: status_button.icon = get_theme_icon("Reload", "EditorIcons")
	if create_branch_button: create_branch_button.icon = get_theme_icon("Add", "EditorIcons")
	if pull_button: pull_button.icon = get_theme_icon("ArrowDown", "EditorIcons")
	if push_button: push_button.icon = get_theme_icon("ArrowUp", "EditorIcons")
	if discard_button: discard_button.icon = get_theme_icon("Undo", "EditorIcons")
	if history_button: history_button.icon = get_theme_icon("History", "EditorIcons")
	if commit_button: commit_button.icon = get_theme_icon("Edit", "EditorIcons")
	if delete_branch_btn:
		delete_branch_btn.icon = get_theme_icon("Remove", "EditorIcons")
		delete_branch_btn.text = ""
	if back_button: back_button.icon = get_theme_icon("Back", "EditorIcons")
	if disconnect_token_button: disconnect_token_button.icon = get_theme_icon("LogOut", "EditorIcons")

func _ensure_gitignore():
	var project_path = ProjectSettings.globalize_path("res://")
	var gitignore_path = project_path + ".gitignore"
	if not FileAccess.file_exists(gitignore_path):
		var file = FileAccess.open(gitignore_path, FileAccess.WRITE)
		if file:
			var content = """# Godot 4+ specific ignores\n.godot/\n*.translation\n\n# Exported games\nexport/\nexport_presets.cfg\nbuilds/\n*.exe\n*.apk\n*.aab\n*.app\n*.ipa\n*.zip\n*.tar.gz\n\n# OS specific\n.DS_Store\nThumbs.db\n"""
			file.store_string(content)
			file.close()
			_print_to_console(T("success_gitignore"))

func _show_view(view_name: String):
	auth_view.hide()
	repos_view.hide()
	workspace_view.hide()
	
	if view_name == "auth":
		auth_view.show()
	elif view_name == "repos":
		repos_view.show()
	elif view_name == "workspace":
		workspace_view.show()

func _check_git_status():
	var project_path = ProjectSettings.globalize_path("res://")
	var dir = DirAccess.open(project_path)
	
	if not dir.dir_exists(".git"):
		_show_view("auth")
		init_button.disabled = false
	else:
		init_button.disabled = true
		_ensure_gitignore()
		
		var output = []
		OS.execute("git", ["remote", "-v"], output, true, true)
		var has_remote = false
		var remote_url = ""
		
		if output.size() > 0 and output[0].length() > 0:
			var lines = output[0].split("\n", false)
			for line in lines:
				if line.begins_with("origin"):
					has_remote = true
					var parts = line.split("\t", false)
					if parts.size() > 1:
						var subparts = parts[1].split(" ", false)
						remote_url = subparts[0]
						break
			
		if not has_remote:
			if fetched_repos.size() > 0:
				_show_view("repos")
			else:
				_show_view("auth")
		else:
			_show_view("workspace")
			if remote_info_label:
				remote_info_label.text = T("remote_info") + remote_url
			
			_update_status_list()
			_update_branches()

func _execute_git(args: Array, update_status_after: bool = true) -> String:
	var output = []
	var exit_code = OS.execute("git", args, output, true, true)
	var result = ""
	if output.size() > 0: result = output[0]
	
	if exit_code != 0:
		_print_to_console(T("err_git") + " ".join(args) + "\n" + result)
	else:
		_print_to_console(T("success_git") + " ".join(args))
		
	if update_status_after:
		_update_status_list()
		_update_branches()
	return result

func _print_to_console(text: String):
	if output_console:
		output_console.text += text + "\n"
		output_console.scroll_vertical = output_console.get_line_count()

func auto_refresh():
	if workspace_view.visible:
		_update_status_list()

func _update_status_list():
	status_list.clear()
	var output = []
	var exit_code = OS.execute("git", ["status", "--short"], output, true, true)
	if exit_code == 0:
		if output.size() > 0:
			var lines = output[0].split("\n")
			for line in lines:
				var text = line.strip_edges()
				if not text.is_empty():
					status_list.add_item(text)
		
		if status_list.item_count == 0:
			status_list.add_item(T("msg_clean_repo"))
			status_list.set_item_disabled(0, true)

func _update_branches():
	if not branch_select: return
	var output = []
	OS.execute("git", ["branch"], output, true, true)
	
	if output.size() > 0:
		branch_select.clear()
		current_branches.clear()
		
		var popup = null
		if delete_branch_button:
			popup = delete_branch_button.get_popup()
			popup.clear()
			
		var lines = output[0].split("\n", false)
		var active_index = 0
		var idx = 0
		
		for line in lines:
			var is_active = line.begins_with("*")
			var branch_name = line.replace("*", "").strip_edges()
			if branch_name.is_empty(): continue
			
			branch_select.add_item(branch_name)
			current_branches.append(branch_name)
			
			if is_active:
				active_index = idx
			elif popup:
				popup.add_item(branch_name, idx)
				
			idx += 1
			
		if active_index < branch_select.item_count:
			branch_select.select(active_index)
			
		if delete_branch_button and popup:
			delete_branch_button.disabled = popup.get_item_count() == 0

# --- GITHUB API INTEGRATION ---

func _get_github_headers() -> PackedStringArray:
	var token = github_token.text.strip_edges()
	return PackedStringArray([
		"Authorization: token " + token,
		"Accept: application/vnd.github.v3+json",
		"User-Agent: GDGitCLI"
	])

func _on_fetch_pressed():
	if github_token.text.strip_edges().is_empty(): return
	loading_label.text = T("loading_fetching")
	loading_label.show()
	current_github_action = "FETCH"
	
	var err = github_request.request("https://api.github.com/user/repos?per_page=100&sort=updated", _get_github_headers(), HTTPClient.METHOD_GET)
	if err != OK: loading_label.text = T("err_req")

func _on_create_github_repo_pressed():
	var repo_name = new_github_repo_name.text.strip_edges()
	if repo_name.is_empty(): return
	
	loading_label.text = T("loading_creating")
	loading_label.show()
	current_github_action = "CREATE"
	
	var body = JSON.stringify({"name": repo_name, "private": true})
	var err = github_request.request("https://api.github.com/user/repos", _get_github_headers(), HTTPClient.METHOD_POST, body)
	if err != OK: loading_label.text = T("err_req")

func _on_delete_repo_pressed():
	var idx = repo_select.get_selected_id()
	if idx >= 0 and idx < repo_select.item_count:
		var full_name = repo_select.get_item_text(idx)
		if full_name.is_empty(): return
		
		loading_label.text = T("loading_deleting")
		loading_label.show()
		current_github_action = "DELETE"
		
		var err = github_request.request("https://api.github.com/repos/" + full_name, _get_github_headers(), HTTPClient.METHOD_DELETE)
		if err != OK: loading_label.text = T("err_req")

func _on_github_request_completed(result, response_code, headers, body):
	if current_github_action == "DELETE":
		if response_code == 204:
			loading_label.text = T("success_del_repo")
			_on_fetch_pressed()
		else:
			loading_label.text = T("err_del_repo") + " (" + str(response_code) + ")"
		return

	if response_code < 200 or response_code >= 300:
		loading_label.text = T("err_api").replace("{code}", str(response_code))
		return
		
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		loading_label.text = T("err_read")
		return
		
	if current_github_action == "FETCH":
		fetched_repos.clear()
		repo_select.clear()
		for repo in json:
			if repo.has("full_name") and repo.has("clone_url"):
				repo_select.add_item(repo["full_name"])
				fetched_repos.append(repo["clone_url"])
		loading_label.hide()
		_show_view("repos")
		
	elif current_github_action == "CREATE":
		if json.has("clone_url"):
			var clone_url = json["clone_url"]
			OS.execute("git", ["remote", "add", "origin", clone_url], [], false, true)
			_check_git_status()
			OS.execute("git", ["fetch", "origin"], [], false, true)

func _on_connect_pressed():
	var idx = repo_select.get_selected_id()
	if idx >= 0 and idx < fetched_repos.size():
		var url = fetched_repos[idx]
		# Se já houver origin, remove para evitar erro fatal
		OS.execute("git", ["remote", "remove", "origin"], [], false, true)
		var output = []
		var exit_code = OS.execute("git", ["remote", "add", "origin", url], output, true, true)
		if exit_code == 0:
			_check_git_status()
			OS.execute("git", ["fetch", "origin"], [], false, true)

func _on_disconnect_token_pressed():
	github_token.text = ""
	fetched_repos.clear()
	repo_select.clear()
	_show_view("auth")

func _on_back_pressed():
	if fetched_repos.size() > 0:
		_show_view("repos")
	else:
		_show_view("auth")

# --- GIT COMMANDS ---

func _on_init_pressed():
	var output = []
	var exit_code = OS.execute("git", ["init"], output, true, true)
	if exit_code == 0:
		_check_git_status()

func _on_branch_selected(index: int):
	if index >= 0 and index < current_branches.size():
		var branch_name = current_branches[index]
		_print_to_console(T("msg_switch_branch") + branch_name)
		_execute_git(["checkout", branch_name])

func _on_create_branch_pressed():
	var new_name = new_branch_name.text.strip_edges()
	if new_name.is_empty():
		_print_to_console(T("err_empty_branch"))
		return
		
	_print_to_console(T("msg_create_branch") + new_name)
	_execute_git(["checkout", "-b", new_name])
	new_branch_name.text = ""

func _on_delete_branch_id_pressed(id: int):
	if id >= 0 and id < current_branches.size():
		var branch_name = current_branches[id]
		var output = []
		var exit_code = OS.execute("git", ["branch", "-D", branch_name], output, true, true)
		if exit_code == 0:
			_print_to_console(T("success_del_branch") + " " + branch_name)
			_update_branches()
		else:
			_print_to_console(T("err_del_branch"))

func _on_status_pressed():
	_update_status_list()
	_update_branches()

func _on_commit_pressed():
	var msg = commit_message.text.strip_edges()
	if msg.is_empty():
		_print_to_console(T("err_empty_commit"))
		return
		
	_print_to_console(T("msg_auto_stage"))
	OS.execute("git", ["add", "."], [], false, true)
	
	_execute_git(["commit", "-m", msg])
	commit_message.text = ""

func _on_pull_pressed():
	var branch_idx = branch_select.get_selected_id()
	var branch_name = "main"
	if branch_idx >= 0 and branch_idx < current_branches.size():
		branch_name = current_branches[branch_idx]
		
	_print_to_console(T("msg_pulling") + branch_name + "...")
	var output = []
	var exit_code = OS.execute("git", ["pull", "origin", branch_name], output, true, true)
	
	if exit_code != 0:
		_print_to_console(T("err_pull") + (output[0] if output.size() > 0 else "Unknown error."))
	elif output.size() > 0:
		_print_to_console(output[0])

func _fix_utf8(text: String) -> String:
	var bytes = PackedByteArray()
	for i in range(text.length()):
		bytes.append(text.unicode_at(i) & 0xFF)
	
	var result = ""
	var idx = 0
	var total = bytes.size()
	while idx < total:
		var b1 = bytes[idx]
		idx += 1
		if b1 < 0x80:
			result += char(b1)
		elif (b1 & 0xE0) == 0xC0:
			if idx < total:
				var b2 = bytes[idx]
				idx += 1
				if (b2 & 0xC0) == 0x80:
					result += char(((b1 & 0x1F) << 6) | (b2 & 0x3F))
				else:
					result += char(b1) + char(b2)
			else:
				result += char(b1)
		elif (b1 & 0xF0) == 0xE0:
			if idx + 1 < total:
				var b2 = bytes[idx]
				var b3 = bytes[idx+1]
				idx += 2
				if (b2 & 0xC0) == 0x80 and (b3 & 0xC0) == 0x80:
					result += char(((b1 & 0x0F) << 12) | ((b2 & 0x3F) << 6) | (b3 & 0x3F))
				else:
					result += char(b1) + char(b2) + char(b3)
			else:
				result += char(b1)
		elif (b1 & 0xF8) == 0xF0:
			if idx + 2 < total:
				var b2 = bytes[idx]
				var b3 = bytes[idx+1]
				var b4 = bytes[idx+2]
				idx += 3
				if (b2 & 0xC0) == 0x80 and (b3 & 0xC0) == 0x80 and (b4 & 0xC0) == 0x80:
					var codepoint = ((b1 & 0x07) << 18) | ((b2 & 0x3F) << 12) | ((b3 & 0x3F) << 6) | (b4 & 0x3F)
					result += char(codepoint)
				else:
					result += char(b1) + char(b2) + char(b3) + char(b4)
			else:
				result += char(b1)
		else:
			result += char(b1)
	return result

func _on_push_pressed():
	var branch_idx = branch_select.get_selected_id()
	var branch_name = "main"
	if branch_idx >= 0 and branch_idx < current_branches.size():
		branch_name = current_branches[branch_idx]
		
	_print_to_console(T("msg_pushing") + branch_name + "...")
	var output = []
	var exit_code = OS.execute("git", ["push", "-u", "origin", branch_name], output, true, true)
	
	if exit_code != 0:
		_print_to_console(T("err_push") + (output[0] if output.size() > 0 else "Unknown error"))
	elif output.size() > 0:
		_print_to_console(output[0])

func _on_history_pressed():
	_print_to_console("--- GIT LOG ---")
	var output = []
	OS.execute("git", ["log", "-n", "10", "--oneline"], output, true, true)
	if output.size() > 0:
		_print_to_console(_fix_utf8(output[0]))

func _on_discard_pressed():
	var items = status_list.get_selected_items()
	if items.size() == 0:
		_print_to_console(T("err_no_file"))
		return
		
	var item_text = status_list.get_item_text(items[0]).strip_edges()
	var first_space = item_text.find(" ")
	if first_space == -1: return
	var file_path = item_text.substr(first_space + 1).strip_edges()
	
	if file_path.is_empty(): return
	
	var output = []
	OS.execute("git", ["checkout", "--", file_path], output, true, true)
	_print_to_console(T("success_discard") + file_path)
	_update_status_list()

func _on_status_list_item_activated(index: int):
	var item_text = status_list.get_item_text(index).strip_edges()
	var first_space = item_text.find(" ")
	if first_space == -1: return
	var file_path = item_text.substr(first_space + 1).strip_edges()
	if file_path.is_empty(): return
	
	var output = []
	OS.execute("git", ["diff", "--", file_path], output, true, true)
	var diff_content = ""
	if output.size() > 0:
		diff_content = output[0]
		
	# Fallback para arquivos novos/untracked (como melhorias.txt)
	if diff_content.strip_edges().is_empty():
		var fallback_output = []
		var dev_null = "NUL" if OS.get_name() == "Windows" else "/dev/null"
		OS.execute("git", ["diff", "--no-index", "--", dev_null, file_path], fallback_output, true, true)
		if fallback_output.size() > 0:
			diff_content = fallback_output[0]
			
	if not diff_content.strip_edges().is_empty():
		var diff_text_fixed = _fix_utf8(diff_content)
		var bbcode = ""
		var lines = diff_text_fixed.split("\n")
		for line in lines:
			var safe_line = line.replace("[", "[lb]").replace("]", "[rb]")
			if safe_line.begins_with("+") and not safe_line.begins_with("+++"):
				bbcode += "[color=green]" + safe_line + "[/color]\n"
			elif safe_line.begins_with("-") and not safe_line.begins_with("---"):
				bbcode += "[color=red]" + safe_line + "[/color]\n"
			elif safe_line.begins_with("@@"):
				bbcode += "[color=cyan]" + safe_line + "[/color]\n"
			else:
				bbcode += safe_line + "\n"
				
		open_diff.emit(file_path, bbcode)
	else:
		_print_to_console("No diff available (untracked or binary file).")
