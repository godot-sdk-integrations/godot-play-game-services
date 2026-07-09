@icon("res://addons/GodotPlayGameServices/assets/icons/players_client.svg")
class_name PlayGamesPlayersClient extends Node
## Client with player functionality.
##
## This autoload exposes methods and signals to control the player information for
## the currently signed in player.

## Signal emitted after calling the [method load_friends] method.[br]
## [br]
## [param friends]: An array containing the friends for the current player.
## The array will be empty if there was an error loading the friends list.
signal friends_loaded(friends: Array[PlayGamesPlayer])

## Signal emitted after selecting a player in the search window opened by the
## [method search_player] method.[br]
## [br]
## [param player]: The selected player.
signal player_searched(player: PlayGamesPlayer)

## Signal emitted after calling the [method load_current_player] method.[br]
## [br]
## [param current_player]: The currently signed-in player, or null if there where
## any errors loading the player.
signal current_player_loaded(current_player: PlayGamesPlayer)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.friendsLoaded.connect(func(friends_json: String):
			var safe_array := GodotPlayGameServices.json_marshaller.safe_parse_array(friends_json)
			var friends: Array[PlayGamesPlayer] = []
			for dictionary: Dictionary in safe_array:
				friends.append(PlayGamesPlayer.new(dictionary))
			
			friends_loaded.emit(friends)
		)
		GodotPlayGameServices.android_plugin.playerSearched.connect(func(friend_json: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(friend_json)
			player_searched.emit(PlayGamesPlayer.new(safe_dictionary))
		)
		GodotPlayGameServices.android_plugin.currentPlayerLoaded.connect(func(friend_json: String):
			var safe_dictionary := GodotPlayGameServices.json_marshaller.safe_parse_dictionary(friend_json)
			current_player_loaded.emit(PlayGamesPlayer.new(safe_dictionary))
		)

## Use this method and subscribe to the emitted signal to receive the list of friends
## for the current player.[br]
## [br]
## The method emits the [signal friends_loaded] signal.[br]
## [br]
## [param page_size]: The number of entries to request for this initial page.[br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.[br]
## [param ask_for_permission]: If the user has not granted access to their friends 
## list, and this is set to true, a new window will open asking the user for permission 
## to their friends list.
func load_friends(page_size: int, force_reload: bool, ask_for_permission: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadFriends(
			page_size,
			force_reload,
			ask_for_permission
		)

## Displays a screen where the user can see a comparison of their own profile
## against another player's profile.[br]
## [br]
## [param other_player_id]: The player ID of the player to compare with.
func compare_profile(other_player_id: String) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.compareProfile(other_player_id)

## Displays a screen where the user can see a comparison of their own profile
## against another player's profile.[br]
## [br]
## Should be used when the game has its own player names separate from the Play 
## Games Services gamer tag. These names will be used in the profile display and 
## only sent to the server if the player initiates a friend invitation to the 
## profile being viewed, so that the sender and recipient have context relevant 
## to their game experience.[br]
## [br]
## [param other_player_id]: The player ID of the player to compare with.[br]
## [param other_player_in_game_name]: The game's own display name of the player referred to by otherPlayerId.[br]
## [param current_player_in_game_name]: The game's own display name of the current player.
func compare_profile_with_alternative_name_hints(
	other_player_id: String,
	other_player_in_game_name: String,
	current_player_in_game_name: String
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.compareProfileWithAlternativeNameHints(
			other_player_id,
			other_player_in_game_name,
			current_player_in_game_name
		)

## Displays a screen where the user can search for players. If the user selects 
## a player, then the [signal player_searched] signal will be emitted, returning
## the selected player.
func search_player() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.searchPlayer()

## Use this method and subscribe to the emitted signal to receive the currently
## signed in player.[br]
## [br]
## The method emits the [signal current_player_loaded] signal.[br]
## [br]
## [param force_reload]: If true, this call will clear any locally cached 
## data and attempt to fetch the latest data from the server. Send it set to [code]true[/code]
## the first time, and [code]false[/code] in subsequent calls, or when you want
## to clear the cache.
func load_current_player(force_reload: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.loadCurrentPlayer(force_reload)
