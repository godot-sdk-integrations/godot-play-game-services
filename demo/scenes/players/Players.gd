extends Control

@onready var back_button: Button = %Back
@onready var search_button: Button = %SearchButton
@onready var search_display: VBoxContainer = %SearchDisplay
@onready var current_player_display: VBoxContainer = %CurrentPlayerDisplay
@onready var friends_display: VBoxContainer = %FriendsDisplay
@onready var play_games_players_client: PlayGamesPlayersClient = %PlayGamesPlayersClient

var _current_player: PlayGamesPlayer
var _friends_cache: Array[PlayGamesPlayer] = []
var _player_display := preload("res://scenes/players/PlayerDisplay.tscn")

func _ready() -> void:
	if not _current_player:
		play_games_players_client.load_current_player(true)
	if _friends_cache.is_empty():
		play_games_players_client.load_friends(10, true, true)
	
	back_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	search_button.pressed.connect(func():
		play_games_players_client.search_player()
	)

func _on_current_player_loaded(current_player: PlayGamesPlayer) -> void:
	var container := _player_display.instantiate() as Control
	container.play_games_player = current_player
	container.play_games_players_client = play_games_players_client
	current_player_display.add_child(container)

func _on_friends_loaded(friends: Array[PlayGamesPlayer]) -> void:
	_friends_cache = friends
	if not _friends_cache.is_empty() and friends_display.get_child_count() == 0:
		for friend: PlayGamesPlayer in _friends_cache:
			var container := _player_display.instantiate() as Control
			container.play_games_player = friend
			container.play_games_players_client = play_games_players_client
			friends_display.add_child(container)

func _on_player_searched(player: PlayGamesPlayer) -> void:
	for child in search_display.get_children():
		child.queue_free()
	var container := _player_display.instantiate() as Control
	container.play_games_player = player
	container.play_games_players_client = play_games_players_client
	container.is_comparable = true
	search_display.add_child(container)
