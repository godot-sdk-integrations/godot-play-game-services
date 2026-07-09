class_name PlayGamesAchievement extends RefCounted
## A class representing a PlayGamesAchievement.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/achievement/Achievement]Achievement[/url].

## Achievement type.
enum Type {
	TYPE_STANDARD = 0, ## A standard achievement.
	TYPE_INCREMENTAL = 1 ## An incremental achievement.
}

## Achievement state.
enum State {
	STATE_UNLOCKED = 0, ## An unlocked achievement.
	STATE_REVEALED = 1, ## A revealed achievement.
	STATE_HIDDEN = 2 ## A hidden achievement.
}

var achievement_id: String ## The achievement id.
var achievement_name: String ## The achievement name.
var description: String ## The description of the achievement.
var player: PlayGamesPlayer ## The player associated to this achievement.
var type: Type ## The achievement type.
var state: State ## The achievement state.
var xp_value: int ## The XP value of this achievement.
var revealed_image_uri: String ## A URI that can be used to load the achievement's revealed image icon.
var unlocked_image_uri: String ## A URI that can be used to load the achievement's unlocked image icon.
## The number of steps this user has gone toward unlocking this achievement;
## only applicable for [code]TYPE_INCREMENTAL[/code] achievement types.
var current_steps: int
## Retrieves the total number of steps necessary to unlock this achievement; 
## only applicable for [code]TYPE_INCREMENTAL[/code] achievement types.
var total_steps: int
## Retrieves the number of steps this user has gone toward unlocking this
## achievement, formatted for the user's locale; only applicable for 
## [code]TYPE_INCREMENTAL[/code] achievement types.
var formatted_current_steps: String
## Loads the total number of steps necessary to unlock this achievement,
## formatted for the user's local; only applicable for [code]TYPE_INCREMENTAL[/code] 
## achievement types.
var formatted_total_steps: String
## Retrieves the timestamp (in millseconds since epoch) at which this achievement 
## was last updated.
var last_updated_timestamp: int

## Constructor that creates an Achievement from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("achievementId"): achievement_id = dictionary.achievementId
	if dictionary.has("name"): achievement_name = dictionary.name
	if dictionary.has("description"): description = dictionary.description
	if dictionary.has("player"): player = PlayGamesPlayer.new(dictionary.player)
	if dictionary.has("type"): type = Type[dictionary.type]
	if dictionary.has("state"): state = State[dictionary.state]
	if dictionary.has("xpValue"): xp_value = dictionary.xpValue
	if dictionary.has("revealedImageUri"): revealed_image_uri = dictionary.revealedImageUri
	if dictionary.has("unlockedImageUri"): unlocked_image_uri = dictionary.unlockedImageUri
	if dictionary.has("currentSteps"): current_steps = dictionary.currentSteps
	if dictionary.has("totalSteps"): total_steps = dictionary.totalSteps
	if dictionary.has("formattedCurrentSteps"): formatted_current_steps = dictionary.formattedCurrentSteps
	if dictionary.has("formattedTotalSteps"): formatted_total_steps = dictionary.formattedTotalSteps
	if dictionary.has("lastUpdatedTimestamp"): last_updated_timestamp = dictionary.lastUpdatedTimestamp

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("achievement_id: %s" % achievement_id)
	result.append("achievement_name: %s" % achievement_name)
	result.append("description: %s" % description)
	result.append("player: {%s}" % str(player))
	result.append("type: %s" % Type.find_key(type))
	result.append("state: %s" % State.find_key(state))
	result.append("xp_value: %s" % xp_value)
	result.append("revealed_image_uri: %s" % revealed_image_uri)
	result.append("unlocked_image_uri: %s" % unlocked_image_uri)
	result.append("current_steps: %s" % current_steps)
	result.append("total_steps: %s" % total_steps)
	result.append("formatted_current_steps: %s" % formatted_current_steps)
	result.append("formatted_total_steps: %s" % formatted_total_steps)
	result.append("last_updated_timestamp: %s" % last_updated_timestamp)
	
	return ", ".join(result)
