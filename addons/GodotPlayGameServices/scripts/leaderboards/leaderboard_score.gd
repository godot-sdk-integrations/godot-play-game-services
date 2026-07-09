class_name PlayGamesLeaderboardScore extends RefCounted
## The score of a player for a specific leaderboard.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/LeaderboardScore]LeaderboardScore[/url].

var display_rank: String ## Formatted string for the rank of the player.
var display_score: String ## Formatted string for the score of the player.
var rank: int ## Rank of the player.
var raw_score: int ## Raw score of the player.
var score_holder: PlayGamesPlayer ## The player object who holds the score.
var score_holder_display_name: String ## Formatted string for the name of the player.
var score_holder_hi_res_image_uri: String ## Hi-res image of the player.
var score_holder_icon_image_uri: String ## Icon image of the player.
var score_tag: String ## Optional score tag associated with this score.
var timestamp_millis: int ## Timestamp (in milliseconds from epoch) at which this score was achieved.

## Constructor that creates a Score from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("displayRank"): display_rank = dictionary.displayRank
	if dictionary.has("displayScore"): display_score = dictionary.displayScore
	if dictionary.has("rank"): rank = dictionary.rank
	if dictionary.has("rawScore"): raw_score = dictionary.rawScore
	if dictionary.has("scoreHolder"): score_holder = PlayGamesPlayer.new(dictionary.scoreHolder)
	if dictionary.has("scoreHolderDisplayName"): score_holder_display_name = dictionary.scoreHolderDisplayName
	if dictionary.has("scoreHolderHiResImageUri"): score_holder_hi_res_image_uri = dictionary.scoreHolderHiResImageUri
	if dictionary.has("scoreHolderIconImageUri"): score_holder_icon_image_uri = dictionary.scoreHolderIconImageUri
	if dictionary.has("scoreTag"): score_tag = dictionary.scoreTag
	if dictionary.has("timestampMillis"): timestamp_millis = dictionary.timestampMillis

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("display_rank: %s" % display_rank)
	result.append("display_score: %s" % display_score)
	result.append("rank: %s" % rank)
	result.append("raw_score: %s" % raw_score)
	result.append("score_holder: {%s}" % str(score_holder))
	result.append("score_holder_display_name: %s" % score_holder_display_name)
	result.append("score_holder_hi_res_image_uri: %s" % score_holder_hi_res_image_uri)
	result.append("score_holder_icon_image_uri: %s" % score_holder_icon_image_uri)
	result.append("score_tag: %s" % score_tag)
	result.append("timestamp_millis: %s" % timestamp_millis)
	
	return ", ".join(result)
