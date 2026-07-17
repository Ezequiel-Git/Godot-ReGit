@tool
extends VBoxContainer

signal close_requested

@onready var title_label = $Header/Title
@onready var close_button = $Header/CloseButton
@onready var diff_text = $ScrollContainer/DiffText

func _ready():
	var lang = "en"
	if Engine.is_editor_hint():
		var settings = EditorInterface.get_editor_settings()
		if settings and settings.has_setting("interface/editor/editor_language"):
			lang = settings.get_setting("interface/editor/editor_language")
	if lang == "": lang = OS.get_locale()
	
	if close_button:
		if lang.begins_with("pt"):
			close_button.text = "❌ Fechar Diff"
		elif lang.begins_with("es"):
			close_button.text = "❌ Cerrar Diff"
		else:
			close_button.text = "❌ Close Diff"
		close_button.pressed.connect(func(): close_requested.emit())

func set_diff(file_path: String, bbcode: String):
	if title_label:
		title_label.text = "Diff: " + file_path.get_file()
	if diff_text:
		diff_text.text = bbcode
