class_name PlayGamesSnapshotMetadata extends RefCounted
## The metadata of a Snapshot.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/snapshot/SnapshotMetadata]SnapshotMetadata[/url].

var snapshot_id: String ## The ID of the snapshot.
var unique_name: String ## The unique identifier of this snapshot. This is the file_name parameter passed to the save_game method.
var description: String ## The description of the snapshot. This is the description parameter passed to the save_game method.
var cover_image_aspect_ratio: int ## The aspect ratio of the cover image for this snapshot.
var progress_value: int  ## The progress value for this snapshot.
var last_modified_timestamp: int ## The last time this snapshot was modified, in millis since epoch.
var played_time: int ## The played time of this snapshot in milliseconds.
var has_change_pending: bool ## Indicates whether or not this snapshot has any changes pending that have not been uploaded to the server.
var owner: PlayGamesPlayer ## The player that owns this snapshot.
var game: PlayGamesGame ## The game information associated with this snapshot.
var device_name: String ## The name of the device that wrote this snapshot, if known.
var cover_image_uri: String ## The snapshot cover image.

## Constructor that creates a SnapshotMetadata from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("snapshotId"): snapshot_id = dictionary.snapshotId
	if dictionary.has("uniqueName"): unique_name = dictionary.uniqueName
	if dictionary.has("description"): description = dictionary.description
	if dictionary.has("coverImageAspectRatio"): cover_image_aspect_ratio = dictionary.coverImageAspectRatio
	if dictionary.has("progressValue"): progress_value = dictionary.progressValue
	if dictionary.has("lastModifiedTimestamp"): last_modified_timestamp = dictionary.lastModifiedTimestamp
	if dictionary.has("playedTime"): played_time = dictionary.playedTime
	if dictionary.has("hasChangePending"): has_change_pending = dictionary.hasChangePending
	if dictionary.has("owner"): owner = PlayGamesPlayer.new(dictionary.owner)
	if dictionary.has("game"): game = PlayGamesGame.new(dictionary.game)
	if dictionary.has("deviceName"): device_name = dictionary.deviceName
	if dictionary.has("coverImageUri"): cover_image_uri = dictionary.coverImageUri

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("snapshot_id: %s" % snapshot_id)
	result.append("unique_name: %s" % unique_name)
	result.append("description: %s" % description)
	result.append("cover_image_aspect_ratio: %s" % cover_image_aspect_ratio)
	result.append("progress_value: %s" % progress_value)
	result.append("last_modified_timestamp: %s" % last_modified_timestamp)
	result.append("played_time: %s" % played_time)
	result.append("has_change_pending: %s" % has_change_pending)
	result.append("owner: {%s}" % str(owner))
	result.append("game: {%s}" % str(game))
	result.append("device_name: %s" % device_name)
	result.append("cover_image_uri: %s" % cover_image_uri)
	
	return ", ".join(result)
