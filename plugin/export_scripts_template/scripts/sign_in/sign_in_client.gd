@icon("res://addons/GodotPlayGameServices/assets/icons/sign_in_client.svg")
class_name PlayGamesSignInClient extends Node
## Client with sign in functionality.
##
## This autoload exposes methods and signals to control the player sign in process.[br]
## [br]
## If the player is already signed in into Google Play Games, the plugin does
## a check at startup, so usually you don't have to use these methods. Use them only 
## to provide a manual way for the user to sign in.

## Additional OAuth scopes that can be requested with the [method request_server_side_access_with_scopes]
## method.[br]
## [br]
## The [code]GAMES_LITE[/code] and [code]DRIVE_APPFOLDER[/code] scopes are always requested,
## so they are not part of this enum. Any of the scopes below has to be granted by the
## player in a consent screen, so they might not be granted at all.
enum AuthScope {
	EMAIL, ## Requests access to the email address of the player.
	PROFILE, ## Requests access to the basic profile information of the player.
	OPEN_ID, ## Requests an OpenID Connect ID token, which is returned together with the access token when your server exchanges the authorization code.
}

## Signal emitted after calling the [method is_authenticated] method.[br]
## [br]
## [param is_authenticated]: Indicates if the user is authenticated or not.
signal user_authenticated(is_authenticated: bool)

## Signal emitted after calling the [method request_server_side_access] method.[br]
## [br]
## [param token]: The OAuth 2.0 authorization code as a string.
signal server_side_access_requested(token:String)

## Signal emitted after calling the [method request_server_side_access_with_scopes] method.[br]
## [br]
## [param token]: The OAuth 2.0 authorization code as a string.[br]
## [param granted_scopes]: The additional scopes granted by the player. It is empty if
## the player declined the consent screen.
signal server_side_access_with_scopes_requested(token: String, granted_scopes: Array[AuthScope])

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.userAuthenticated.connect(func(is_authenticated: bool):
			user_authenticated.emit(is_authenticated)
		)
		GodotPlayGameServices.android_plugin.serverSideAccessRequested.connect(func(token: String):
			server_side_access_requested.emit(token)
		)
		GodotPlayGameServices.android_plugin.serverSideAccessWithScopesRequested.connect(func(token: String, granted_scopes: PackedInt32Array):
			var scopes: Array[AuthScope] = []
			for scope: int in granted_scopes:
				scopes.append(scope as AuthScope)
			server_side_access_with_scopes_requested.emit(token, scopes)
		)

## Use this method to check if the user is already authenticated. If the user is authenticated,
## a popup will be shown on screen.[br]
## [br]
## The method emits the [signal user_authenticated] signal.
func is_authenticated() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.isAuthenticated()

## Use this method to provide a manual way to the user for signing in.[br]
## [br]
## The method emits the [signal user_authenticated] signal.
func sign_in() -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.signIn()

## Requests server-side access to Play Games Services for the currently signed-in player.
## When requested, an authorization code is returned that can be used by your server to exchange
## for an access token that can be used by your server to access the Play Games Services web APIs.[br]
## [br]
## The method emits the [signal server_side_access_requested] signal.[br]
## [br]
## [param server_client_id]: The client ID of the server that will perform the authorization code flow exchange.[br]
## [param force_refresh_token]: If true, when the returned authorization code is exchanged, a refresh
## token will be included in addition to an access token.
func request_server_side_access(server_client_id: String, force_refresh_token: bool) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.requestServerSideAccess(server_client_id, force_refresh_token)

## Requests server-side access to Play Games Services for the currently signed-in player,
## asking the player to also grant the given additional scopes.[br]
## [br]
## Works like the [method request_server_side_access] method, but requesting the
## [constant AuthScope.OPEN_ID] scope makes the authorization code exchange return an
## OpenID Connect ID token as well, so your server can identify the player with the same
## [code]sub[/code] a browser sign in would give you.[br]
## [br]
## The player can decline the consent screen, in which case none of the additional scopes
## are granted, so check the [code]granted_scopes[/code] of the emitted signal before
## relying on any of them.[br]
## [br]
## The method emits the [signal server_side_access_with_scopes_requested] signal.[br]
## [br]
## [param server_client_id]: The client ID of the server that will perform the authorization code flow exchange.[br]
## [param force_refresh_token]: If true, when the returned authorization code is exchanged, a refresh
## token will be included in addition to an access token.[br]
## [param scopes]: The additional scopes to request. See the [enum AuthScope] enum.
func request_server_side_access_with_scopes(
	server_client_id: String,
	force_refresh_token: bool,
	scopes: Array[AuthScope]
) -> void:
	if GodotPlayGameServices.android_plugin:
		GodotPlayGameServices.android_plugin.requestServerSideAccessWithScopes(server_client_id, force_refresh_token, scopes)
