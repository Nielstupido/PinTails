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
	SINGLE_TRIGGER, ##skills that activates after pressing "skill hotkey"
	SHOT_TRIGGER, ##skills that activates when "skill hotkey" is pressed and followed by pressing "left-mouse button"
	TIMED_SHOT_TRIGGER, ##skills that activates when "skill hotkey" is pressed and followed by pressing "left-mouse button" within a duration
	TOGGLE_TRIGGER, ##skills that needs to be toggled
	DOUBLE_TRIGGER ##skills that activates when "skill hotkey" is pressed and followed by pressing again the "skill hotkey"
}
