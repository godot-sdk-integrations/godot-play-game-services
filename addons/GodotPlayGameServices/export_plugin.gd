@tool
extends EditorPlugin

const PLUGIN_AUTOLOAD := &"GodotPlayGameServices"

var _export_plugin : AndroidExportPlugin
var _dock : Node

func _enter_tree() -> void:
	_add_plugin()
	_add_docks()
	_add_autoloads()

func _exit_tree() -> void:
	_remove_plugin()
	_remove_docks()
	_remove_autoloads()

func _add_plugin() -> void:
	_export_plugin = AndroidExportPlugin.new()
	add_export_plugin(_export_plugin)

func _remove_plugin() -> void:
	remove_export_plugin(_export_plugin)
	_export_plugin = null

func _add_docks() -> void:
	var dock_name := &"Godot Play Game Services"
	_dock = preload("res://addons/GodotPlayGameServices/godot_play_game_services_dock.tscn").instantiate()
	add_control_to_bottom_panel(_dock, dock_name)

func _remove_docks() -> void:
	remove_control_from_bottom_panel(_dock)
	_dock.free()

func _add_autoloads() -> void:
	add_autoload_singleton(PLUGIN_AUTOLOAD, "res://addons/GodotPlayGameServices/scripts/autoloads/godot_play_game_services.gd")

func _remove_autoloads() -> void:
	remove_autoload_singleton(PLUGIN_AUTOLOAD)

class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = &"GodotPlayGameServices"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([_plugin_name + "/bin/debug/" + _plugin_name + "-debug.aar"])
		else:
			return PackedStringArray([_plugin_name + "/bin/release/" + _plugin_name + "-release.aar"])
	
	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if not _supports_platform(platform):
			return PackedStringArray()
		
		return PackedStringArray([
			"com.google.code.gson:gson:2.11.0", 
			"com.google.android.gms:play-services-games-v2:21.0.0"
			])
	
	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		if not _supports_platform(platform):
			return ""
		
		return "<meta-data android:name=\"com.google.android.gms.games.APP_ID\" android:value=\"@string/game_services_project_id\"/>"

	func _get_name():
		return _plugin_name
