package com.jacobibanez.plugin.android.godotplaygameservices.achievements

import com.google.android.gms.games.achievement.Achievement
import com.google.android.gms.games.achievement.Achievement.TYPE_INCREMENTAL
import com.jacobibanez.plugin.android.godotplaygameservices.players.fromPlayer
import com.jacobibanez.plugin.android.godotplaygameservices.utils.toStringAndMaybeSave
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot

/** @suppress */
fun fromAchievement(godot: Godot, achievement: Achievement, loadImages: Boolean = true) = Dictionary().apply {
    put("achievementId", achievement.achievementId)
    put("name", achievement.name)
    put("description", achievement.description)
    put("player", fromPlayer(godot, achievement.player, loadImages))
    put("xpValue", achievement.xpValue)
    put("currentSteps", if (achievement.type == TYPE_INCREMENTAL) achievement.currentSteps else 0)
    put("totalSteps", if (achievement.type == TYPE_INCREMENTAL) achievement.totalSteps else 0)
    put("lastUpdatedTimestamp", achievement.lastUpdatedTimestamp)
    Type.fromType(achievement.type)?.let { put("type", it.name) }
    State.fromState(achievement.state)?.let { put("state", it.name) }
    if (achievement.type == TYPE_INCREMENTAL) {
        achievement.formattedCurrentSteps?.let { put("formattedCurrentSteps", it) }
    }
    if (achievement.type == TYPE_INCREMENTAL) {
        achievement.formattedTotalSteps?.let { put("formattedTotalSteps", it) }
    }
    achievement.revealedImageUri?.let {
        put(
            "revealedImageUri",
            it.toStringAndMaybeSave(
                godot,
                "revealedImageUri",
                achievement.achievementId,
                loadImages
            )
        )
    }
    achievement.unlockedImageUri?.let {
        put(
            "unlockedImageUri",
            it.toStringAndMaybeSave(
                godot,
                "unlockedImageUri",
                achievement.achievementId,
                loadImages
            )
        )
    }
}
