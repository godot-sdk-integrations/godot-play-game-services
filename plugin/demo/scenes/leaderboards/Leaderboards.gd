extends Control

@onready var back_button: Button = %Back
@onready var show_leaderboards_button: Button = %ShowLeaderboards
@onready var leaderboard_displays: VBoxContainer = %LeaderboardDisplays
@onready var play_games_leaderboards_client: PlayGamesLeaderboardsClient = %PlayGamesLeaderboardsClient

var _leaderboards_cache: Array[PlayGamesLeaderboard] = []
var _leaderboard_display := preload("res://scenes/leaderboards/LeaderboardDisplay.tscn")

func _ready() -> void:
	if _leaderboards_cache.is_empty():
		play_games_leaderboards_client.load_all_leaderboards(true)
	
	back_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	show_leaderboards_button.pressed.connect(func():
		play_games_leaderboards_client.show_all_leaderboards()
	)

func _on_all_leaderboards_loaded(leaderboards: Array[PlayGamesLeaderboard]) -> void:
	_leaderboards_cache = leaderboards
	if not _leaderboards_cache.is_empty():
		for leaderboard: PlayGamesLeaderboard in _leaderboards_cache:
			var container := _leaderboard_display.instantiate() as Control
			container.play_games_leaderboard = leaderboard
			container.play_games_leaderboards_client = play_games_leaderboards_client
			leaderboard_displays.add_child(container)
