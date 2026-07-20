@icon("res://addons/GodotPlayGameServices/assets/icons/snapshots_client.svg")
class_name PlayGamesSnapshotsClient extends Node
## Client with save and load games functionality.
##
## This autoload exposes methods and signals to save and load games in the Google cloud of the player.

## Signal emitted after calling the [method save_game] method.[br]
## [br]
## [param is_saved]: Wheter if the game was saved or not.[br]
## [param save_data_name]: The save file name.[br]
## [param save_data_description]: The save file description.
signal game_saved(is_saved: bool, save_data_name: String, save_data_description: String)

## Signal emitted after calling the [method load_game] method or after selecting
## a saved game in the window presented after calling the [method show_saved_games]
## method.[br]
## [br]
## [param snapshot]: The loaded snapshot, or null if the snapshot wasn't found.
signal game_loaded(snapshot: PlayGamesSnapshot)

## Signal emitted after saving or loading a game, if a conflict is found.[br]
## [br]
## [param conflict]: The conflict containing and id and both conflicting snapshots.
signal conflict_emitted(conflict: PlayGamesSnapshotConflict)

## Signal emitted after calling the [method load_snapshots] method.[br]
## [br]
## [param snapshots]: The list of snapshots for the current signed in player.
signal snapshots_loaded(snapshots: Array[PlayGamesSnapshotMetadata])

func _ready() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.gameSaved.connect(
			func(is_saved: bool, save_data_name: String, save_data_description: String):
				game_saved.emit(is_saved, save_data_name, save_data_description)
		)
		GodotPlayGameServices.android_plugin.gameLoaded.connect(func(json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			if safe_dictionary.is_empty():
				game_loaded.emit(null)
			else:
				game_loaded.emit(PlayGamesSnapshot.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.conflictEmitted.connect(func(json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			conflict_emitted.emit(PlayGamesSnapshotConflict.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.snapshotsLoaded.connect(func(json_data: String):
			var safe_array := GodotPlayGameServices.json_marshaller.safe_parse_array(json_data)
			var snapshots: Array[PlayGamesSnapshotMetadata] = []
			for dictionary: Dictionary in safe_array:
				snapshots.append(PlayGamesSnapshotMetadata.new(dictionary))
			snapshots_loaded.emit(snapshots)
		)

## Opens a new window to display the saved games for the current player. If you select
## a saved game, the [signal game_loaded] signal will be emitted.[br]
## [br]
## [param title]: The title to display in the action bar of the returned Activity.[br]
## [param allow_add_button]: Whether or not to display a "create new snapshot" option in the selection UI.[br]
## [param allow_delete]: Whether or not to provide a delete overflow menu option for each snapshot in the selection UI.[br]
## [param max_snapshots]: The maximum number of snapshots to display in the UI. Use [constant DISPLAY_LIMIT_NONE] to display all snapshots.
func show_saved_games(
	title: String,
	allow_add_button: bool,
	allow_delete: bool,
	max_snapshots: int
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showSavedGames(title, allow_add_button, allow_delete, max_snapshots)

## Saves game data to the Google Cloud.[br]
## [br]
## This method emits the [signal game_saved] signal.[br]
## [br]
## [param fileName]: The name of the save file. Must be between 1 and 100 non-URL-reserved characters (a-z, A-Z, 0-9, or the symbols "-", ".", "_", or "~").[br]
## [param saveData]: A String with the saved data of the game.[br]
## [param played_time_millis]: Optional. The played time of this snapshot in milliseconds.[br]
## [param progress_value]: Optional. The progress value for this snapshot.
func save_game(
	file_name: String,
	description: String,
	save_data: PackedByteArray,
	played_time_millis: int = 0,
	progress_value: int = 0,
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.saveGame(file_name, description, save_data, played_time_millis, progress_value)

## Loads game data from the Google Cloud.[br]
## [br]
## This method emits the [signal game_loaded] signal.[br]
## [br]
## [param fileName]: The name of the save file. Must be between 1 and 100 non-URL-reserved charactes (a-z, A-Z, 0-9, or the symbols "-", ".", "_", or "~").[br]
## [param create_if_not_found]: False by default. If true, the snapshot will be created if one cannot be found.
func load_game(file_name: String, create_if_not_found := false) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadGame(file_name, create_if_not_found)

## Loads the list of [SnapshotMetadata] of the current signed in player.[br]
## [br]
## This method emits the [signal snapshots_loaded] signal.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_snapshots(force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadSnapshots(force_reload)

## Deletes a snapshot. This will delete the data of the snapshot locally and on the server.[br]
## [br]
## [param snapshot_id]: The snapshot identifier.
func delete_snapshot(snapshot_id: String) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.deleteSnapshot(snapshot_id)
