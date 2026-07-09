@tool
extends EditorPlugin

const PLUGIN_AUTOLOAD := &"GodotPlayGameServices"

var _export_plugin: AndroidExportPlugin

func _enter_tree() -> void:
	_add_plugin()
	_add_autoloads()

func _exit_tree() -> void:
	_remove_plugin()
	_remove_autoloads()

func _add_plugin() -> void:
	_export_plugin = AndroidExportPlugin.new()
	add_export_plugin(_export_plugin)

func _remove_plugin() -> void:
	remove_export_plugin(_export_plugin)
	_export_plugin = null

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


	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		var id = get_option("godot_play_game_services/game_id")
		if id == "":
			printerr("[{plugin_name}] Export [Game id] is empty.".format({"plugin_name": _plugin_name}))
			print("Please add your game-id here: [Project > Export > Android > godot_play_game_services/game_id].")
			return

		var file := FileAccess.open("android/build/res/values/strings.xml", FileAccess.WRITE)
		file.store_string("<?xml version=\"1.0\" encoding=\"utf-8\"?><resources><string translatable=\"false\" name=\"game_services_project_id\">%s</string></resources>" % id)
		[]

		print("[{plugin_name}] added game-id {id} to [values/strings.xml]".format({"plugin_name": _plugin_name, "id": id}))

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

	func _get_export_options(platform: EditorExportPlatform) -> Array[Dictionary]:
		var options: Array[Dictionary] = []

		if platform.get_os_name() != "Android":
			return options

		# exposes game id within game's export settings.
		options.append({
			"option": {
				"name": "godot_play_game_services/game_id",
				"type": TYPE_STRING,
				"hint": "",
				"hint_string": "google play services game id."
			},
			"default_value": ""
		})
		return options
