extends Control

@onready var title_label: Label = %TitleLabel
@onready var sign_in_button: Button = %SignInButton
@onready var achievements_button: Button = %AchievementsButton
@onready var leaderboards_button: Button = %LeaderboardsButton
@onready var players_button: Button = %PlayersButton
@onready var snapshots_button: Button = %SnapshotsButton
@onready var play_games_sign_in_client: PlayGamesSignInClient = %PlayGamesSignInClient

func _enter_tree() -> void:
	GodotPlayGameServices.initialize()

func _ready() -> void:
	if not GodotPlayGameServices.android_plugin:
		title_label.text = "Plugin Not Found!"
	else:
		title_label.text = "Main Menu"
	
	play_games_sign_in_client.is_authenticated()
	sign_in_button.pressed.connect(func():
		play_games_sign_in_client.sign_in()
	)
	achievements_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/achievements/Achievements.tscn")
	)
	leaderboards_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/leaderboards/Leaderboards.tscn")
	)
	players_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/players/Players.tscn")
	)
	snapshots_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/snapshots/Snapshots.tscn")
	)

func _on_user_authenticated(is_authenticated: bool) -> void:
	print("Hi from Godot! User is authenticated? %s" % is_authenticated)
	_change_sign_in_button_visibility(!is_authenticated)

func _change_sign_in_button_visibility(is_button_visible: bool) -> void:
	sign_in_button.visible = is_button_visible
	
	achievements_button.disabled = is_button_visible
	leaderboards_button.disabled = is_button_visible
	players_button.disabled = is_button_visible
	snapshots_button.disabled = is_button_visible
