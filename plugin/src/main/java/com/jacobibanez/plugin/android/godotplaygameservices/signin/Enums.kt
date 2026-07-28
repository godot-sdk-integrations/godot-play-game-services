package com.jacobibanez.plugin.android.godotplaygameservices.signin

import com.google.android.gms.games.gamessignin.AuthScope as GamesAuthScope

/**
 * Additional OAuth scopes that can be requested when asking for server side access.
 *
 * The `GAMES_LITE` and `DRIVE_APPFOLDER` scopes are always requested, so they are not part of this
 * enum. Any of the scopes below has to be granted by the player in a consent screen, so they might
 * not be granted at all.
 */
enum class AuthScope(
    /**
     * Integer representation of the scope, matching the `AuthScope` enum of the GDScript client.
     */
    val value: Int,

    /**
     * The [com.google.android.gms.games.gamessignin.AuthScope](https://developers.google.com/android/reference/com/google/android/gms/games/gamessignin/AuthScope) this scope maps to.
     */
    val gamesAuthScope: GamesAuthScope
) {
    /**
     * Requests access to the email address of the player.
     */
    EMAIL(0, GamesAuthScope.EMAIL),

    /**
     * Requests access to the basic profile information of the player.
     */
    PROFILE(1, GamesAuthScope.PROFILE),

    /**
     * Requests an OpenID Connect ID token, which is returned together with the access token when
     * the server exchanges the authorization code.
     */
    OPEN_ID(2, GamesAuthScope.OPEN_ID);

    companion object {
        /**
         * Returns an [AuthScope] given its integer representation, or null if the value is invalid.
         */
        fun fromValue(value: Int): AuthScope? = when (value) {
            EMAIL.value -> EMAIL
            PROFILE.value -> PROFILE
            OPEN_ID.value -> OPEN_ID
            else -> null
        }

        /**
         * Returns an [AuthScope] given its Google counterpart, or null if the given scope is not one
         * of the additional scopes exposed by the plugin.
         */
        fun fromGamesAuthScope(gamesAuthScope: GamesAuthScope): AuthScope? = when (gamesAuthScope) {
            GamesAuthScope.EMAIL -> EMAIL
            GamesAuthScope.PROFILE -> PROFILE
            GamesAuthScope.OPEN_ID -> OPEN_ID
            else -> null
        }
    }
}
