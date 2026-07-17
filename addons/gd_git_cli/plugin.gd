@tool
extends EditorPlugin

var dock
var active_diffs = []

func _enter_tree():
	dock = preload("res://addons/gd_git_cli/git_dock.tscn").instantiate()
	add_control_to_bottom_panel(dock, "Git CLI")
	
	if dock.has_signal("open_diff"):
		dock.open_diff.connect(_on_open_diff)
	
	# Auto-refresh hook
	var fs = get_editor_interface().get_resource_filesystem()
	if not fs.filesystem_changed.is_connected(_on_filesystem_changed):
		fs.filesystem_changed.connect(_on_filesystem_changed)

func _exit_tree():
	if dock:
		remove_control_from_bottom_panel(dock)
		dock.free()
		
	for diff_view in active_diffs:
		if is_instance_valid(diff_view):
			remove_control_from_bottom_panel(diff_view)
			diff_view.free()
	active_diffs.clear()
		
	var fs = get_editor_interface().get_resource_filesystem()
	if fs and fs.filesystem_changed.is_connected(_on_filesystem_changed):
		fs.filesystem_changed.disconnect(_on_filesystem_changed)

func _on_filesystem_changed():
	if dock and dock.has_method("auto_refresh"):
		dock.auto_refresh()

func _on_open_diff(file_path: String, diff_bbcode: String):
	var diff_view = preload("res://addons/gd_git_cli/git_diff_view.tscn").instantiate()
	
	var title = "Diff: " + file_path.get_file()
	add_control_to_bottom_panel(diff_view, title)
	diff_view.set_diff(file_path, diff_bbcode)
	make_bottom_panel_item_visible(diff_view)
	
	active_diffs.append(diff_view)
	
	diff_view.close_requested.connect(func():
		remove_control_from_bottom_panel(diff_view)
		active_diffs.erase(diff_view)
		diff_view.queue_free()
	)
