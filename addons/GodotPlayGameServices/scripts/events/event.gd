class_name PlayGamesEvent extends RefCounted
## A class representing an Event from Google Play Games Services.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/event/Event]Event[/url].

var description: String ## The description for this event.
var event_id: String ## The ID of this event.
var formatted_value: String ## The sum of increments have been made to this event (formatted for the user's locale).
var icon_image_uri: String ## The URI to the event's image icon.
var name: String ## The name of this event.
var player: PlayGamesPlayer ## The player information associated with this event.
var value: int ## The number of increments this user has made to this event.
var is_visible: bool ## Whether the event should be displayed to the user in any event related UIs.

## Constructor that creates a PlayGamesEvent from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	print(dictionary)
	if dictionary.has("description"): description = dictionary.description
	if dictionary.has("eventId"): event_id = dictionary.eventId
	if dictionary.has("formattedValue"): formatted_value = dictionary.formattedValue
	if dictionary.has("iconImageUri"): icon_image_uri = dictionary.iconImageUri
	if dictionary.has("name"): name = dictionary.name
	if dictionary.has("player"): player = PlayGamesPlayer.new(dictionary.player)
	if dictionary.has("value"): value = dictionary.value
	if dictionary.has("isVisible"): is_visible = dictionary.isVisible

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("description: %s" % description)
	result.append("event_id: %s" % event_id)
	result.append("formatted_value: %s" % formatted_value)
	result.append("icon_image_uri: %s" % icon_image_uri)
	result.append("name: %s" % name)
	result.append("player: {%s}" % str(player))
	result.append("value: %s" % value)
	result.append("is_visible: %s" % is_visible)
	
	return ", ".join(result)
