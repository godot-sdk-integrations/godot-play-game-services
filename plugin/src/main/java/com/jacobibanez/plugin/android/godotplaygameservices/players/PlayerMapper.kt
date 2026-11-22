package com.jacobibanez.plugin.android.godotplaygameservices.players

import com.google.android.gms.games.Player
import com.google.android.gms.games.PlayerLevel
import com.google.android.gms.games.PlayerLevelInfo
import com.jacobibanez.plugin.android.godotplaygameservices.utils.toStringAndMaybeSave
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot

/** @suppress */
fun fromPlayer(godot: Godot, player: Player, loadImages: Boolean = true) = Dictionary().apply {
    put("displayName", player.displayName)
    put("playerId", player.playerId)
    put("retrievedTimestamp", player.retrievedTimestamp)
    put("title", player.title)
    put("hasHiResImage", player.hasHiResImage())
    put("hasIconImage", player.hasIconImage())
    player.levelInfo?.let { put("levelInfo", fromPlayerLevelInfo(it)) }
    player.currentPlayerInfo?.let { currentPlayerInfo ->
        FriendsListVisibilityStatus.fromStatus(currentPlayerInfo.friendsListVisibilityStatus)
            ?.let {
                put("friendsListVisibilityStatus", it.name)
            }
    }
    player.relationshipInfo?.let { relationshipInfo ->
        PlayerFriendStatus.fromStatus(relationshipInfo.friendStatus)?.let {
            put("friendStatus", it.name)
        }
    }
    player.bannerImageLandscapeUri?.let {
        put(
            "bannerImageLandscapeUri",
            it.toStringAndMaybeSave(
                godot,
                "bannerImageLandscapeUri",
                player.playerId,
                loadImages
            )
        )
    }
    player.bannerImagePortraitUri?.let {
        put(
            "bannerImagePortraitUri",
            it.toStringAndMaybeSave(
                godot,
                "bannerImagePortraitUri",
                player.playerId,
                loadImages
            )
        )
    }
    player.hiResImageUri?.let {
        put(
            "hiResImageUri",
            it.toStringAndMaybeSave(
                godot,
                "hiResImageUri",
                player.playerId,
                loadImages
            )
        )
    }
    player.iconImageUri?.let {
        put(
            "iconImageUri",
            it.toStringAndMaybeSave(
                godot,
                "iconImageUri",
                player.playerId,
                loadImages
            )
        )
    }
}

/** @suppress */
fun fromPlayerLevelInfo(levelInfo: PlayerLevelInfo) = Dictionary().apply {
    put("currentLevel", fromPlayerLevel(levelInfo.currentLevel))
    put("currentXpTotal", levelInfo.currentXpTotal)
    put("lastLevelUpTimestamp", levelInfo.lastLevelUpTimestamp)
    put("nextLevel", fromPlayerLevel(levelInfo.nextLevel))
    put("isMaxLevel", levelInfo.isMaxLevel)
}

/** @suppress */
fun fromPlayerLevel(playerLevel: PlayerLevel) = Dictionary().apply {
    put("levelNumber", playerLevel.levelNumber)
    put("maxXp", playerLevel.maxXp)
    put("minXp", playerLevel.minXp)
}
