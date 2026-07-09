class_name PlayGamesGame extends RefCounted
## A class with information about a game.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/Game]Game[/url].

var are_snapshots_enabled: bool ## Indicates whether or not this game supports snapshots.
var achievement_total_count: int ## The number of achievements registered for this game.
var application_id: String ## The application ID for this game.
var description: String ## The description of this game.
var developer_name: String ## The name of the developer of this game.
var display_name: String ## The display name for this game.
var leaderboard_count: int ## The number of leaderboards registered for this game.
var primary_category: String ## The primary category of the game.
var secondary_category: String ## The secondary category of the game.
var theme_color: String ## The theme color for this game.
var has_gamepad_support: bool ## Indicates whether or not this game is marked as supporting gamepads.
var hi_res_image_uri: String ## The game's hi-res image.
var icon_image_uri: String ## The game's icon.
var featured_image_uri: String ## The game's featured (banner) image from Google Play.

## Constructor that creates a Game from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("areSnapshotsEnabled"): are_snapshots_enabled = dictionary.areSnapshotsEnabled
	if dictionary.has("achievementTotalCount"): achievement_total_count = dictionary.achievementTotalCount
	if dictionary.has("applicationId"): application_id = dictionary.applicationId
	if dictionary.has("description"): description = dictionary.description
	if dictionary.has("developerName"): developer_name = dictionary.developerName
	if dictionary.has("displayName"): display_name = dictionary.displayName
	if dictionary.has("leaderboardCount"): leaderboard_count = dictionary.leaderboardCount
	if dictionary.has("primaryCategory"): primary_category = dictionary.primaryCategory
	if dictionary.has("secondaryCategory"): secondary_category = dictionary.secondaryCategory
	if dictionary.has("themeColor"): theme_color = dictionary.themeColor
	if dictionary.has("hasGamepadSupport"): has_gamepad_support = dictionary.hasGamepadSupport
	if dictionary.has("hiResImageUri"): hi_res_image_uri = dictionary.hiResImageUri
	if dictionary.has("iconImageUri"): icon_image_uri = dictionary.iconImageUri
	if dictionary.has("featuredImageUri"): featured_image_uri = dictionary.featuredImageUri

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("are_snapshots_enabled: %s" % are_snapshots_enabled)
	result.append("achievement_total_count: %s" % achievement_total_count)
	result.append("application_id: %s" % application_id)
	result.append("description: %s" % description)
	result.append("developer_name: %s" % developer_name)
	result.append("display_name: %s" % display_name)
	result.append("leaderboard_count: %s" % leaderboard_count)
	result.append("primary_category: %s" % primary_category)
	result.append("secondary_category: %s" % secondary_category)
	result.append("theme_color: %s" % theme_color)
	result.append("has_gamepad_support: %s" % has_gamepad_support)
	result.append("hi_res_image_uri: %s" % hi_res_image_uri)
	result.append("icon_image_uri: %s" % icon_image_uri)
	result.append("featured_image_uri: %s" % featured_image_uri)
	
	return ", ".join(result)
