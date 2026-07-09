class_name PlayGamesPlayerLevel extends RefCounted
## The level of a player.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/PlayerLevel]PlayerLevel[/url].

var level_number: int ## The number for this level.
var max_xp: int ## The maximum XP value represented by this level, exclusive.
var min_xp: int ## The minimum XP value needed to attain this level, inclusive.

## Constructor that creates a PlayGamesPlayerLevel from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("levelNumber"): level_number = dictionary.levelNumber
	if dictionary.has("maxXp"): max_xp = dictionary.maxXp
	if dictionary.has("minXp"): min_xp = dictionary.minXp

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("level_number: %s" % level_number)
	result.append("max_xp: %s" % max_xp)
	result.append("min_xp: %s" % min_xp)
	
	return ", ".join(result)
