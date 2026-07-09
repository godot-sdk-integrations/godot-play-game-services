class_name PlayGamesLeaderboardScores extends RefCounted
## A class holding a list of scores for a leaderboard.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/LeaderboardsClient.LeaderboardScores]LeaderboardScores[/url].

var leaderboard: PlayGamesLeaderboard ## The leaderboard.
var scores: Array[PlayGamesLeaderboardScore] ## The list of scores for this leaderboard.

## Constructor that creates a LeaderboardScores from a [Dictionary] containting
## the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("leaderboard"): leaderboard = PlayGamesLeaderboard.new(dictionary.leaderboard)
	if dictionary.has("scores"):
		for score: Dictionary in dictionary.scores:
			scores.append(PlayGamesLeaderboardScore.new(score))

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("leaderboard: %s" % leaderboard)
	
	for score: PlayGamesLeaderboardScore in scores:
		result.append("{%s}" % str(score))
	
	return ", ".join(result)
