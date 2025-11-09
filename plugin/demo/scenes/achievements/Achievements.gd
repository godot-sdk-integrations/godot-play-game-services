extends Control

@onready var back_button: Button = %Back
@onready var show_achievements_button: Button = %ShowAchievements
@onready var achievement_displays: VBoxContainer = %AchievementDisplays
@onready var play_games_achievements_client: PlayGamesAchievementsClient = %PlayGamesAchievementsClient

var _achievements_cache: Array[PlayGamesAchievement] = []
var _achievement_display := preload("res://scenes/achievements/AchievementDisplay.tscn")

func _ready() -> void:
	if _achievements_cache.is_empty():
		play_games_achievements_client.load_achievements(true)
	
	back_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	show_achievements_button.pressed.connect(func():
		play_games_achievements_client.show_achievements()
	)

func _on_achievements_loaded(achievements: Array[PlayGamesAchievement]) -> void:
	_achievements_cache = achievements
	if not _achievements_cache.is_empty() and achievement_displays.get_child_count() == 0:
		for achievement: PlayGamesAchievement in _achievements_cache:
			var container := _achievement_display.instantiate() as Control
			container.play_games_achievement = achievement
			container.play_games_achievements_client = play_games_achievements_client
			achievement_displays.add_child(container)
