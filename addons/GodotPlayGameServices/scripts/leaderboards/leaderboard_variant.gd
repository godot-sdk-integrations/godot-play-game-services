class_name PlayGamesLeaderboardVariant extends RefCounted
## A specific variant of [enum TimeSpan] and [enum Collection] for a leaderboard.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/LeaderboardVariant]LeaderboardVariant[/url].

## Time span for leaderboards.
enum TimeSpan {
	TIME_SPAN_DAILY = 0, ## A leaderboard that resets everyday.
	TIME_SPAN_WEEKLY = 1, ## A leaderboard that resets every week.
	TIME_SPAN_ALL_TIME = 2 ## A leaderboard that never resets.
}

## Collection type for leaderboards.
enum Collection {
	COLLECTION_PUBLIC = 0, ## A public leaderboard.
	COLLECTION_FRIENDS = 3 ## A leaderboard only with friends.
}

var display_player_rank: String ## The formatted rank of the player for this variant.
var display_player_score: String ## The formatted score of the player for this variant.
var num_scores: int ## The total number of scores for this variant.
var player_rank: int ## The rank of the player for this variant.
var player_score_tag: String ## The score tag of the player for this variant.
var raw_player_score: int ## The score of the player for this variant.
var has_player_info: bool ## Whether or not this variant contains score information for the player.
var collection: Collection ## The type of [enum Collection] of this variant.
var time_span: TimeSpan ## The type of [enum TimeSpan] of this variant.

## Constructor that creates a LeaderboardVariant from a [Dictionary] containting
## the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("displayPlayerRank"): display_player_rank = dictionary.displayPlayerRank
	if dictionary.has("displayPlayerScore"): display_player_score = dictionary.displayPlayerScore
	if dictionary.has("numScores"): num_scores = dictionary.numScores
	if dictionary.has("playerRank"): player_rank = dictionary.playerRank
	if dictionary.has("playerScoreTag"): player_score_tag = dictionary.playerScoreTag
	if dictionary.has("rawPlayerScore"): raw_player_score = dictionary.rawPlayerScore
	if dictionary.has("hasPlayerInfo"): has_player_info = dictionary.hasPlayerInfo
	if dictionary.has("collection"): collection = Collection.get(dictionary.collection)
	if dictionary.has("timeSpan"): time_span = TimeSpan.get(dictionary.timeSpan)

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("display_player_rank: %s" % display_player_rank)
	result.append("display_player_score: %s" % display_player_score)
	result.append("num_scores: %s" % num_scores)
	result.append("player_rank: %s" % player_rank)
	result.append("player_score_tag: %s" % player_score_tag)
	result.append("raw_player_score: %s" % raw_player_score)
	result.append("has_player_info: %s" % has_player_info)
	result.append("collection: %s" % str(collection))
	result.append("time_span: %s" % str(time_span))
	
	return ", ".join(result)
