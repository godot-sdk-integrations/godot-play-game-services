class_name PlayGamesLeaderboard extends RefCounted
## A leaderboard.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/Leaderboard]Leaderboard[/url].

## Score order for leadeboards.
enum ScoreOrder {
	SCORE_ORDER_LARGER_IS_BETTER = 1, ## Scores are sorted in descending order.
	SCORE_ORDER_SMALLER_IS_BETTER = 0 ## Scores are sorted in ascending order.
}

var leaderboard_id: String ## The leaderboard id.
var display_name: String ## The display name of the leaderboard.
var icon_image_uri: String ## The URI to the leaderboard icon image.
var score_order: ScoreOrder ## The sorting order of the leaderboard, based on the score.
## A list of variants of this leaderboard, based on the combination of the
## leaderboard [enum TimeSpan] and [enum Collection].
var variants: Array[PlayGamesLeaderboardVariant] = []

## Constructor that creates a Leaderboard from a [Dictionary] containing the
## properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("leaderboardId"): leaderboard_id = dictionary.leaderboardId
	if dictionary.has("displayName"): display_name = dictionary.displayName
	if dictionary.has("iconImageUri"): icon_image_uri = dictionary.iconImageUri
	if dictionary.has("scoreOrder"): score_order = ScoreOrder.get(dictionary.scoreOrder)
	if dictionary.has("variants"):
		for variant: Dictionary in dictionary.variants:
			variants.append(PlayGamesLeaderboardVariant.new(variant))

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("leaderboard_id: %s" % leaderboard_id)
	result.append("display_name: %s" % display_name)
	result.append("icon_image_uri: %s" % icon_image_uri)
	result.append("score_order: %s" % ScoreOrder.find_key(score_order))
	
	for variant: PlayGamesLeaderboardVariant in variants:
		result.append("{%s}" % str(variant))
	
	return ", ".join(result)
