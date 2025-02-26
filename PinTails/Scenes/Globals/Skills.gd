@tool
extends Node


enum Skill_Effects {
	DEFAULT,
	DAMAGE,
	ARMOR,
	DASH,
	STICK
}

enum Skill_Types {
	DEFAULT,
	SINGLE_TRIGGER, ##skills that activates main effect/action after pressing "skill hotkey"
	SHOT_TRIGGER, ##skills that activates when "skill hotkey" is pressed and followed by pressing "left-mouse button" main effect/action
	TIMED_SHOT_TRIGGER, ##skills that activates when "skill hotkey" is pressed and followed by pressing "left-mouse button" within a duration to trigger main effect/action
	TOGGLE_TRIGGER, ##skills that needs to be toggled for the effect/action
	DOUBLE_TRIGGER, ##skills that activates when "skill hotkey" is pressed and followed by pressing again the "skill hotkey" to take effect
	WAIT_SHOT_TRIGGER ##skills that activates first effect/action when "skill hotkey" is pressed and followed by pressing "left-mouse button" to trigger main effect/action
}
