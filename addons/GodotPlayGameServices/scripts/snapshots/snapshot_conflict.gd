class_name PlayGamesSnapshotConflict extends RefCounted
## A class representing a conflict when saving or loading data.
##
## This is a GDSCript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/SnapshotsClient.SnapshotConflict]SnapshotConflict[/url].

var origin: String ## The original caller of the method, either "SAVE" or "LOAD"
var conflict_id: String ## The conflict id.
var conflicting_snapshot: PlayGamesSnapshot ## The modified version of the Snapshot in the case of a conflict. This may not be the same as the version that you tried to save.
var server_snapshot: PlayGamesSnapshot ## The most-up-to-date version of the Snapshot known by Google Play games services to be accurate for the player’s device.

## Constructor that creates a SnapshotConflict from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("origin"): origin = dictionary.origin
	if dictionary.has("conflictId"): conflict_id = dictionary.conflictId
	if dictionary.has("conflictingSnapshot"): conflicting_snapshot = PlayGamesSnapshot.new(dictionary.conflictingSnapshot)
	if dictionary.has("serverSnapshot"): server_snapshot = PlayGamesSnapshot.new(dictionary.serverSnapshot)

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("origin: %s" % origin)
	result.append("conflict_id: %s" % conflict_id)
	result.append("conflicting_snapshot: {%s}" % conflicting_snapshot)
	result.append("server_snapshot: {%s}" % server_snapshot)
	
	return ", ".join(result)
