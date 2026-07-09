@icon("res://addons/GodotPlayGameServices/assets/icons/events_client.svg")
class_name PlayGamesEventsClient extends Node
## Client with events functionality.
##
## This node has methods and signals to control your game events.

## Signal emitted after calling the [method load_events] method.[br]
## [br]
## [param events]: The list of events.
signal events_loaded(events: Array[PlayGamesEvent])

## Signal emitted after calling the [method load_events_by_ids] method.[br]
## [br]
## [param events]: The list of events.
signal events_loaded_by_ids(events: Array[PlayGamesEvent])

func _ready() -> void:
	_connect_signals()

## Increments an event specified by eventId by the given number of steps.[br]
## [br]
## This is the fire-and-forget API. Event increments are cached locally and flushed
## to the server in batches.[br]
## [br]
## [param event_id]: The event ID to increment.[br]
## [param increment_amount]: The amount to increment by. Must be greater than or equal to 0.
func increment_event(event_id: String, increment_amount: int) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.incrementEvent(event_id, increment_amount)

## Loads a list of events for the currently signed-in player.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_events(force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadEvents(force_reload)

## Loads a specific list of events for the currently signed-in player.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.[br]
## [param event_ids]: The IDs of the events to load.
func load_events_by_ids(force_reload: bool, event_ids: Array[String]) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadEventsByIds(force_reload, event_ids)

func _connect_signals() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.eventsLoaded.connect(_on_events_loaded)
		GodotPlayGameServices.android_plugin.eventsLoadedByIds.connect(_on_events_loadeds_by_ids)

func _on_events_loaded(json_data: String) -> void:
	events_loaded.emit(_parse_events(json_data))

func _on_events_loadeds_by_ids(json_data: String) -> void:
	events_loaded.emit(_parse_events(json_data))

func _parse_events(json_data: String) -> Array[PlayGamesEvent]:
	var safe_array := GodotPlayGameServices.json_marshaller.safe_parse_array(json_data)
	var events: Array[PlayGamesEvent] = []
	for dictionary: Dictionary in safe_array:
		events.append(PlayGamesEvent.new(dictionary))
	return events
