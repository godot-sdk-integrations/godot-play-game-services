class_name PlayGamesPlayer extends RefCounted
## PlayGamesPlayer information.
##
## This is a GDScript representation of Google's [url=https://developers.google.com/android/reference/com/google/android/gms/games/Player]Player[/url].

## Friends list visibility statuses.
enum FriendsListVisibilityStatus {
	FEATURE_UNAVAILABLE = 3, ## The friends list is currently unavailable for the game.
	REQUEST_REQUIRED = 2, ## The friends list is not visible to the game, but the game can ask for access.
	UNKNOWN = 0, ## Unknown if the friends list is visible to the game, or whether the game can ask for access from the user.
	VISIBLE = 1 ## The friends list is currently visible to the game.
}

## This player's friend status relative to the currently signed in player.
enum PlayGamesPlayerFriendStatus {
	FRIEND = 4, ## The currently signed in player and this player are friends.
	NO_RELATIONSHIP = 0, ## The currently signed in player is not a friend of this player.
	UNKNOWN = -1 ## The currently signed in player's friend status with this player is unknown.
}

var banner_image_landscape_uri: String ## Banner image of the player in landscape.
var banner_image_portrait_uri: String ## Banner image of the player in portrait.
var friends_list_visibility_status: FriendsListVisibilityStatus ## Visibility status of this player's friend list.
var display_name: String ## The display name of the player.
var hi_res_image_uri: String ## The hi-res image of the player.
var icon_image_uri: String ## The icon image of the player.
var level_info: PlayGamesPlayerLevelInfo ## Information about the player level.
var player_id: String ## The player id.
var friend_status: PlayGamesPlayerFriendStatus ## The friend status of this player with the signed in player.
var retrieved_timestamp: int ## The timestamp at which this player record was last updated locally.
var title: String ## The title of the player.
var has_hi_res_image: bool ## Whether this player has a hi-res profile image to display.
var has_icon_image: bool ## Whether this player has an icon-size profile image to display.

## Constructor that creates a PlayGamesPlayer from a [Dictionary] containing the properties.
func _init(dictionary: Dictionary) -> void:
	if dictionary.has("bannerImageLandscapeUri"): banner_image_landscape_uri = dictionary.bannerImageLandscapeUri
	if dictionary.has("bannerImagePortraitUri"): banner_image_portrait_uri = dictionary.bannerImagePortraitUri
	if dictionary.has("friendsListVisibilityStatus"): friends_list_visibility_status = FriendsListVisibilityStatus.get(dictionary.friendsListVisibilityStatus)
	if dictionary.has("displayName"): display_name = dictionary.displayName
	if dictionary.has("hiResImageUri"): hi_res_image_uri = dictionary.hiResImageUri
	if dictionary.has("iconImageUri"): icon_image_uri = dictionary.iconImageUri
	if dictionary.has("levelInfo"): level_info = PlayGamesPlayerLevelInfo.new(dictionary.levelInfo)
	if dictionary.has("playerId"): player_id = dictionary.playerId
	if dictionary.has("friendStatus"): friend_status = PlayGamesPlayerFriendStatus.get(dictionary.friendStatus)
	if dictionary.has("retrievedTimestamp"): retrieved_timestamp = dictionary.retrievedTimestamp
	if dictionary.has("title"): title = dictionary.title
	if dictionary.has("hasHiResImage"): has_hi_res_image = dictionary.hasHiResImage
	if dictionary.has("hasIconImage"): has_icon_image = dictionary.hasIconImage

func _to_string() -> String:
	var result := PackedStringArray()
	
	result.append("banner_image_landscape_uri: %s" % banner_image_landscape_uri)
	result.append("banner_image_portrait_uri: %s" % banner_image_portrait_uri)
	result.append("friends_list_visibility_status: %s" % FriendsListVisibilityStatus.find_key(friends_list_visibility_status))
	result.append("display_name: %s" % display_name)
	result.append("hi_res_image_uri: %s" % hi_res_image_uri)
	result.append("icon_image_uri: %s" % icon_image_uri)
	result.append("level_info: {%s}" % str(level_info))
	result.append("player_id: %s" % player_id)
	result.append("friend_status: %s" % PlayGamesPlayerFriendStatus.find_key(friend_status))
	result.append("retrieved_timestamp: %s" % retrieved_timestamp)
	result.append("title: %s" % title)
	result.append("has_hi_res_image: %s" % has_hi_res_image)
	result.append("has_icon_image: %s" % has_icon_image)
	
	return ", ".join(result)
