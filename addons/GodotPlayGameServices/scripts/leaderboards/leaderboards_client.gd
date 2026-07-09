@icon("res://addons/GodotPlayGameServices/assets/icons/leaderboards_client.svg")
class_name PlayGamesLeaderboardsClient extends Node
## Client with  leaderboards functionality.
##
## This autoload exposes methods and signals to show the game leaderboards, as well
## as submitting and retrieving the player's score.

## Signal emitted after calling the [method submit_score] method.[br]
## [br]
## [param is_submitted]: Indicates if the score was submitted or not.[br]
## [param leaderboard_id]: The leaderboard id.
signal score_submitted(is_submitted: bool, leaderboard_id: String)

## Signal emitted after calling the [method load_player_score] method.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param score]: The score of the player. It can be null if there is an error
## retrieving it.
signal score_loaded(leaderboard_id: String, score: PlayGamesLeaderboardScore)

## Signal emitted after calling the [method load_player_centered_scores] method.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param leaderboard_scores]: The scores for the leaderboard, centered in the player.
signal player_centered_scores_loaded(leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores)

## Signal emitted after calling the [method load_top_scores] method.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param leaderboard_scores]: The top scores for the leaderboard.
signal top_scores_loaded(leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores)

## Signal emitted after calling the [method load_all_leaderboards] method.[br]
## [br]
## [param leaderboards]: An array containing all the leaderboards for the game.
## The array will be empty if there was an error loading the leaderboards.
signal all_leaderboards_loaded(leaderboards: Array[PlayGamesLeaderboard])

## Signal emitted after calling the [method load_leaderboard] method.[br]
## [br]
## [param leaderboard]: The leaderboard. It can be null if there is an error
## retrieving it.
signal leaderboard_loaded(leaderboard: PlayGamesLeaderboard)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.scoreSubmitted.connect(func(is_submitted: bool, leaderboard_id: String):
			score_submitted.emit(is_submitted, leaderboard_id)
		)
		GodotPlayGameServices.android_plugin.scoreLoaded.connect(func(leaderboard_id: String, json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			score_loaded.emit(leaderboard_id, PlayGamesLeaderboardScore.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.allLeaderboardsLoaded.connect(func(leaderboards_json: String):
			var safe_array := GodotPlayGameServices.json_marshaller.safe_parse_array(leaderboards_json)
			var leaderboards: Array[PlayGamesLeaderboard] = []
			for dictionary: Dictionary in safe_array:
				leaderboards.append(PlayGamesLeaderboard.new(dictionary))
			all_leaderboards_loaded.emit(leaderboards)
		)
		GodotPlayGameServices.android_plugin.leaderboardLoaded.connect(func(json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			leaderboard_loaded.emit(PlayGamesLeaderboard.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.playerCenteredScoresLoaded.connect(func(leaderboard_id: String, json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			player_centered_scores_loaded.emit(leaderboard_id, PlayGamesLeaderboardScores.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.topScoresLoaded.connect(func(leaderboard_id: String, json_data: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(json_data)
			top_scores_loaded.emit(leaderboard_id, PlayGamesLeaderboardScores.new(safe_dictionary))
		)

## Use this method to show all leaderbords for this game in a new screen.
func show_all_leaderboards() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showAllLeaderboards()

## Use this method to show a specific leaderboard in a new screen.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.
func show_leaderboard(leaderboard_id: String) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showLeaderboard(leaderboard_id)

## Use this method to show a specific leaderboard for a given time span in a new screen.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param time_span]: The time span for the leaderboard. See the [enum TimeSpan] enum.
func show_leaderboard_for_time_span(leaderboard_id: String, time_span: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showLeaderboardForTimeSpan(leaderboard_id, time_span)

## Use this method to show a specific leaderboard for a given time span and 
## collection type in a new screen.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param time_span]: The time span for the leaderboard. See the [enum TimeSpan] enum.[br]
## [param collection]: The collection type for the leaderboard. See the [enum Collection] enum.
func show_leaderboard_for_time_span_and_collection(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showLeaderboardForTimeSpanAndCollection(leaderboard_id, time_span, collection)

## Submits the score to the leaderboard for the currently signed in player. The score 
## is ignored if it is worse (as defined by the leaderboard configuration) than a previously
## submitted score for the same player.[br]
## [br]
## The method emits the [signal score_submitted] signal.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param score]: The raw score value.
func submit_score(leaderboard_id: String, score: int) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.submitScore(leaderboard_id, score)

## Use this method and subscribe to the emitted signal to receive the score of the
## currently signed in player for the specified leaderboard, time span, and collection.[br]
## [br]
## The method emits the [signal score_loaded] signal.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param time_span]: The time span for the leaderboard. See the [enum TimeSpan] enum.[br]
## [param collection]: The collection type for the leaderboard. See the [enum Collection] enum.
func load_player_score(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadPlayerScore(leaderboard_id, time_span, collection)

## Use this method and subscribe to the emitted signal to receive the list of the game
## leaderboards.[br]
## [br]
## The method emits the [signal all_leaderboards_loaded] signal.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_all_leaderboards(force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadAllLeaderboards(force_reload)

## Use this method and subscribe to the emitted signal to receive a leaderboard.[br]
## [br]
## The method emits the [signal leaderboard_loaded] signal.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_leaderboard(leaderboard_id: String, force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadLeaderboard(leaderboard_id, force_reload)

## Use this method and subscribe to the emitted signal to receive an object containing
## the selected leaderboard and an array of scores for that leaderboard, centered in the
## currently signed in player.[br]
## [br]
## The method emits the [signal player_centered_scores_loaded] signal.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param time_span]: The time span for the leaderboard. See the [enum TimeSpan] enum.[br]
## [param collection]: The collection type for the leaderboard. See the [enum Collection] enum.[br]
## [param max_results]: The maximum number of scores to fetch per page. Must be between 1 and 25.
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_player_centered_scores(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection,
	max_results: int,
	force_reload: bool
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadPlayerCenteredScores(
			leaderboard_id,
			time_span,
			collection,
			max_results,
			force_reload
		)

## Use this method and subscribe to the emitted signal to receive an object containing
## the selected leaderboard and an array of the top scores for that leaderboard.[br]
## [br]
## The method emits the [signal top_scores_loaded] signal.[br]
## [br]
## [param leaderboard_id]: The leaderboard id.[br]
## [param time_span]: The time span for the leaderboard. See the [enum TimeSpan] enum.[br]
## [param collection]: The collection type for the leaderboard. See the [enum Collection] enum.[br]
## [param max_results]: The maximum number of scores to fetch per page. Must be between 1 and 25.
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_top_scores(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection,
	max_results: int,
	force_reload: bool
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadTopScores(
			leaderboard_id,
			time_span,
			collection,
			max_results,
			force_reload
		)
