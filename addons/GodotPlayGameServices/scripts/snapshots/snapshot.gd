class_name PlayGamesSnapshot extends RefCounted
## A snapshot.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/snapshot/Snapshot]Snapshot[/url].

## Constant passed to the [method show_saved_games] method to not limit the number of displayed saved files.  
const DISPLAY_LIMIT_NONE := -1

var content: PackedByteArray ## A [PackedByteArray] with the contents of the snapshot.
var metadata: PlayGamesSnapshotMetadata ## The metadata of the snapshot.

## Constructor that creates a Snapshot from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("content"): content = dictionary.content
	if dictionary.has("metadata"): metadata = PlayGamesSnapshotMetadata.new(dictionary.metadata)

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("content: %s" % content)
	result.append("metadata: {%s}" % metadata)
	
	return ", ".join(result)
