extends Control

## DialogueSystem - Dialogic 2.0 Integration
## Handles dialogue display using Dialogic's timeline system

signal dialogue_started
signal dialogue_ended
signal choice_presented(choices: Array)

# UI References
@onready var dialogic_node: Node = null

# State
var current_timeline: String = ""
var is_playing: bool = false

func _ready():
	# Dialogic will be available after plugin is enabled
	# This is a placeholder - actual Dialogic node will be added in scene
	pass

## Start a chapter using Dialogic timeline
func start_chapter(chapter_id: String) -> bool:
	if not _check_dialogic():
		return false
	
	current_timeline = "res://dialogic/timelines/chapter_%s.dtl" % chapter_id
	
	if not FileAccess.file_exists(current_timeline):
		push_error("Timeline not found: %s" % current_timeline)
		return false
	
	# Start Dialogic timeline
	Dialogic.start(current_timeline)
	is_playing = true
	dialogue_started.emit()
	
	# Connect to Dialogic signals
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	return true

## Handle timeline end
func _on_timeline_ended():
	is_playing = false
	dialogue_ended.emit()
	
	# Disconnect signals
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	if Dialogic.signal_event.is_connected(_on_dialogic_signal):
		Dialogic.signal_event.disconnect(_on_dialogic_signal)

## Handle custom signals from timeline
func _on_dialogic_signal(argument: String):
	# Parse custom signals from timeline
	# Example: [signal arg="unlock_clue:scene_intro"]
	
	var parts = argument.split(":", true, 1)
	if parts.size() < 2:
		return
	
	var signal_type = parts[0]
	var signal_data = parts[1]
	
	match signal_type:
		"unlock_clue":
			_unlock_clue(signal_data)
		"trust_change":
			_change_trust(int(signal_data))
		"play_bgm":
			_play_bgm(signal_data)
		"location_change":
			_change_location(signal_data)

## Game-specific functions
func _unlock_clue(clue_id: String):
	print("Clue unlocked: %s" % clue_id)
	# TODO: Emit signal to ClueManager or save to game state

func _change_trust(amount: int):
	print("Trust changed: %d" % amount)
	# TODO: Update trust system

func _play_bgm(track: String):
	print("Play BGM: %s" % track)
	# TODO: Connect to AudioManager

func _change_location(location: String):
	print("Location changed: %s" % location)
	# TODO: Update game state

## Check if Dialogic is available
func _check_dialogic() -> bool:
	if not Engine.has_singleton("Dialogic"):
		push_error("Dialogic plugin not enabled!")
		return false
	return true

## Input handling
func _input(event):
	if not is_playing:
		return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			# Progress dialogue (Dialogic handles this automatically via input)
			pass
