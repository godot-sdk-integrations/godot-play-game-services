@icon("res://addons/GodotPlayGameServices/assets/icons/achievements_client.svg")
class_name PlayGamesAchievementsClient extends Node
## Client with achievements functionality.
##
## This autoload exposes methods and signals to control the game achievements for
## the currently signed in player.

## Signal emitted after calling the [method increment_achievement] 
## or [method unlock_achievement] methods.[br]
## [br]
## [param is_unlocked]: Indicates if the achievement is unlocked or not.[br]
## [param achievement_id]: The achievement id.
signal achievement_unlocked(is_unlocked: bool, achievement_id: String)

## Signal emitted after calling the [method load_achievements] method.[br]
## [br]
## [param achievements]: An array containing all the achievements for the game.
## The array will be empty if there was an error loading the achievements.
signal achievements_loaded(achievements: Array[PlayGamesAchievement])

## Signal emitted after calling the [method reveal_achievement] method.[br]
## [br]
## [param is_revealed]: Indicates if the achievement is revealed or not.[br]
## [param achievement_id]: The achievement id.
signal achievement_revealed(is_revealed: bool, achievement_id: String)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.achievementUnlocked.connect(func(is_unlocked: bool, achievement_id: String):
			achievement_unlocked.emit(is_unlocked, achievement_id)
		)
		GodotPlayGameServices.android_plugin.achievementsLoaded.connect(func(achievements_json: String):
			var safe_array := GodotPlayGameServices.json_marshaller.safe_parse_array(achievements_json)
			var achievements: Array[PlayGamesAchievement] = []
			for dictionary: Dictionary in safe_array:
				achievements.append(PlayGamesAchievement.new(dictionary))
			
			achievements_loaded.emit(achievements)
		)
		GodotPlayGameServices.android_plugin.achievementRevealed.connect(func(is_revealed: bool, achievement_id: String):
			achievement_revealed.emit(is_revealed, achievement_id)
		)

## Use this method to increment a given achievement in the given amount. For normal 
## achievements, use the [method unlock_achievement] method instead.[br]
## [br]
## The method emits the [signal achievement_unlocked] signal.[br]
## [br]
## [param achievement_id]: The achievement id.[br]
## [param amount]: The number of steps to increment by. Must be greater than 0.
func increment_achievement(achievement_id: String, amount: int) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.incrementAchievement(achievement_id, amount)

## Use this method and subscribe to the emitted signal to receive the list of the game
## achievements.[br]
## [br]
## The method emits the [signal achievements_loaded] signal.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_achievements(force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadAchievements(force_reload)

## Use this method to reveal a hidden achievement to the current signed in player. 
## If the achievement is already unlocked, this method will have no effect.[br]
## [br]
## The method emits the [signal achievement_revealed] signal.[br]
## [br]
## [param achievement_id]: The achievement id.
func reveal_achievement(achievement_id: String) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.revealAchievement(achievement_id)

## Use this method to open a new window with the achievements of the game, and 
## the progress of the player made so far to unlock those achievements.
func show_achievements() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.showAchievements()

## Immediately unlocks the given achievement for the signed in player. If the 
## achievement is secret, it will be revealed to the player.[br]
## [br]
## The method emits the [signal achievement_unlocked] signal.[br]
## [br]
## [param achievement_id]: The achievement id.
func unlock_achievement(achievement_id: String) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.unlockAchievement(achievement_id)

## Immediately set the given achievement for the signed in player to have at least the given number of steps completed.[br]
## Calling this method when the achievement already has more than the provided steps is a no-op.[br]
## Once the achievement reaches the maximum number of steps, the achievement will automatically be unlocked, and any further mutation operations will be ignored.
## [br]
## The method emits the [signal achievement_unlocked] signal.[br]
## [br]
## [param achievement_id]: The achievement id.[br]
## [param num_steps]: The number of steps to set the achievement to. Must be greater than 0.
func set_achievement_steps(achievement_id: String, num_steps: int) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.setAchievementSteps(achievement_id, num_steps)
