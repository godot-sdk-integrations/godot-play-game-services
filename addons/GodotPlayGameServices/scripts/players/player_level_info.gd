class_name PlayGamesPlayerLevelInfo extends RefCounted
## The current level information of a player.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/PlayerLevelInfo]PlayerLevelInfo[/url].

var current_level: PlayGamesPlayerLevel ## The player's current level object.
var current_xp_total: int ## The player's current XP value.
var last_level_up_timestamp: int ## The timestamp of the player's last level-up.
var next_level: PlayGamesPlayerLevel ## The player's next level object.
var is_max_level: bool ## True if the player reached the maximum level ([member PlayGamesPlayerLevelInfo.current_level] is the same as [member PlayGamesPlayerLevelInfo.next_level]).

## Constructor that creates a PlayGamesPlayerLevelInfo from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("currentLevel"): current_level = PlayGamesPlayerLevel.new(dictionary.currentLevel)
	if dictionary.has("currentXpTotal"): current_xp_total = dictionary.currentXpTotal
	if dictionary.has("lastLevelUpTimestamp"): last_level_up_timestamp = dictionary.lastLevelUpTimestamp
	if dictionary.has("nextLevel"): next_level = PlayGamesPlayerLevel.new(dictionary.nextLevel)
	if dictionary.has("isMaxLevel"): is_max_level = dictionary.isMaxLevel

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("current_level: {%s}" % str(current_level))
	result.append("current_xp_total: %s" % current_xp_total)
	result.append("last_level_up_timestamp: %s" % last_level_up_timestamp)
	result.append("next_level: {%s}" % str(next_level))
	result.append("is_max_level: %s" % is_max_level)
	
	return ", ".join(result)
