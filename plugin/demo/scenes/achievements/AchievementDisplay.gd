extends Control

@onready var icon_rect: TextureRect = %IconRect

@onready var id_label: Label = %IdLabel
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var type_label: Label = %TypeLabel
@onready var state_label: Label = %StateLabel
@onready var xp_value_label: Label = %XPValueLabel

@onready var current_steps_holder: HBoxContainer = %CurrentStepsHolder
@onready var current_steps_label: Label = %CurrentStepsLabel
@onready var total_steps_holder: HBoxContainer = %TotalStepsHolder
@onready var total_steps_label: Label = %TotalStepsLabel

@onready var unlock_holder: VBoxContainer = %UnlockHolder
@onready var unlock_button: Button = %UnlockButton

var play_games_achievement: PlayGamesAchievement
var play_games_achievements_client: PlayGamesAchievementsClient

var _waiting := false

func _ready() -> void:
	if play_games_achievement:
		_set_up_display()
		_set_up_button_pressed()
		_connect_signals()

func _set_up_display() -> void:
	id_label.text = play_games_achievement.achievement_id
	name_label.text = play_games_achievement.achievement_name
	description_label.text = play_games_achievement.description
	type_label.text = PlayGamesAchievement.Type.find_key(play_games_achievement.type)
	state_label.text = PlayGamesAchievement.State.find_key(play_games_achievement.state)
	xp_value_label.text = str(play_games_achievement.xp_value)
	
	if play_games_achievement.type == PlayGamesAchievement.Type.TYPE_INCREMENTAL:
		current_steps_holder.visible = true
		current_steps_label.text = play_games_achievement.formatted_current_steps
		total_steps_holder.visible = true
		total_steps_label.text = play_games_achievement.formatted_total_steps
	
	match play_games_achievement.state:
		PlayGamesAchievement.State.STATE_UNLOCKED:
			unlock_button.text = "Unlocked!"
			unlock_button.disabled = true
		PlayGamesAchievement.State.STATE_HIDDEN:
			unlock_button.text = "Reveal!"
			unlock_button.disabled = false
		PlayGamesAchievement.State.STATE_REVEALED:
			match play_games_achievement.type:
				PlayGamesAchievement.Type.TYPE_INCREMENTAL:
					unlock_button.text = "Increment!"
					unlock_button.disabled = false
				PlayGamesAchievement.Type.TYPE_STANDARD:
					unlock_button.text = "Unlock!"
					unlock_button.disabled = false

func _set_up_button_pressed() -> void:
	unlock_button.pressed.connect(func():
		match play_games_achievement.state:
			PlayGamesAchievement.State.STATE_HIDDEN:
				play_games_achievements_client.reveal_achievement(play_games_achievement.achievement_id)
				_set_up_waiting()
			PlayGamesAchievement.State.STATE_REVEALED:
				match play_games_achievement.type:
					PlayGamesAchievement.Type.TYPE_INCREMENTAL:
						play_games_achievements_client.increment_achievement(
							play_games_achievement.achievement_id,
							1
						)
						_set_up_waiting()
					PlayGamesAchievement.Type.TYPE_STANDARD:
						play_games_achievements_client.unlock_achievement(
							play_games_achievement.achievement_id
						)
						_set_up_waiting()
	)

func _connect_signals() -> void:
	play_games_achievements_client.achievement_revealed.connect(
		func refresh_achievement(_is_revealed: bool, achievement_id: String):
			if achievement_id ==play_games_achievement.achievement_id and _waiting:
				play_games_achievements_client.load_achievements(true)
	)
	play_games_achievements_client.achievement_unlocked.connect(
		func refresh_achievement(_is_unlocked: bool, achievement_id: String):
			if achievement_id == play_games_achievement.achievement_id and _waiting:
				play_games_achievements_client.load_achievements(true)
	)
	play_games_achievements_client.achievements_loaded.connect(
		func refresh_achievement(achievements: Array[PlayGamesAchievement]):
			for new_achievement: PlayGamesAchievement in achievements:
				if new_achievement.achievement_id == play_games_achievement.achievement_id \
				and _waiting:
					play_games_achievement = new_achievement
					_waiting = false
					_set_up_display()
	)
	GodotPlayGameServices.image_stored.connect(func(file_path: String):
		if file_path == play_games_achievement.revealed_image_uri\
		or file_path == play_games_achievement.unlocked_image_uri:
			_set_up_icon()
	)

func _set_up_waiting() -> void:
	_waiting = true
	unlock_button.disabled = true
	unlock_button.text = "Wait..."

func _set_up_icon() -> void:
	var property: String
	match play_games_achievement.state:
		PlayGamesAchievement.State.STATE_REVEALED:
			property = play_games_achievement.revealed_image_uri
		PlayGamesAchievement.State.STATE_UNLOCKED:
			property = play_games_achievement.unlocked_image_uri
	
	if property and not property.is_empty():
		GodotPlayGameServices.display_image_in_texture_rect(
			icon_rect,
			property
		)
