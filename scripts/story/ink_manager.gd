extends Node

# Ink Manager - Handles Ink story runtime
# Uses godot-ink plugin (Godot 4.x compatible)
# Plugin: https://github.com/paulloz/godot-ink

var story: InkStory
var current_chapter = ""

signal line_displayed(type: String, speaker: String, text: String)
signal choice_presented(choices: Array)
signal clue_unlocked(clue_id: String)
signal trust_changed(amount: int)
signal chapter_ended()

func _ready():
	# godot-ink will be loaded via plugin
	pass

## Load and start a chapter
func load_chapter(chapter_id: String):
	current_chapter = chapter_id
	var ink_path = "res://ink/" + chapter_id + ".ink"
	
	if not ResourceLoader.exists(ink_path):
		push_error("Ink file not found: " + ink_path)
		return false
	
	# Load Ink resource directly (GodotInk handles compilation)
	var ink_resource = load(ink_path)
	
	if not ink_resource:
		push_error("Failed to load Ink resource")
		return false
	
	# InkStory is the loaded resource itself
	story = ink_resource
	
	# TODO: Bind external functions if GodotInk supports it
	# Check GodotInk documentation for external function binding
	
	print("Chapter loaded: ", chapter_id)
	return true

## Continue the story
func continue_story() -> bool:
	if not story or not story.CanContinue:
		return false
	
	var line = story.Continue()
	_process_line(line)
	
	# Check for choices
	if story.CurrentChoices.size() > 0:
		var choices = []
		for choice in story.CurrentChoices:
			choices.append(choice.Text)
		choice_presented.emit(choices)
		return false
	
	return story.CanContinue

## Make a choice
func make_choice(choice_index: int):
	if not story or story.CurrentChoices.size() == 0:
		return
	
	story.ChooseChoiceIndex(choice_index)
	continue_story()

## Process a single line from Ink
func _process_line(line: String):
	# Remove leading/trailing whitespace
	line = line.strip_edges()
	
	if line.is_empty():
		return
	
	# Parse tags
	var tags = story.CurrentTags if story else []
	var line_type = "narration"
	var speaker = ""
	var emotion = ""
	
	for tag in tags:
		if tag.begins_with("CHARACTER:"):
			var parts = tag.substr(11).split("|")
			speaker = parts[0].strip_edges()
			if parts.size() > 1:
				emotion = parts[1].strip_edges()
			line_type = "character"
		elif tag.begins_with("THOUGHT"):
			line_type = "thought"
		elif tag.begins_with("NARRATION"):
			line_type = "narration"
		elif tag.begins_with("SFX:"):
			var sfx_name = tag.substr(5).strip_edges()
			_play_sound_effect(sfx_name)
		elif tag.begins_with("PAUSE:"):
			var duration = float(tag.substr(7).strip_edges())
			await get_tree().create_timer(duration).timeout
		elif tag.begins_with("CLUE_FOUND:"):
			var clue_id = tag.substr(12).strip_edges()
			clue_unlocked.emit(clue_id)
	
	# Emit the processed line
	line_displayed.emit(line_type, speaker, line)

## External function callbacks
func _on_unlock_clue(clue_id: String):
	clue_unlocked.emit(clue_id)

func _on_trust_change(amount: int):
	trust_changed.emit(amount)

func _on_choice_made(choice_id: String):
	print("Choice made: ", choice_id)
	# Can be used for analytics or save system

func _on_play_bgm(track_name: String):
	# Connect to AudioManager
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_bgm(track_name)

func _play_sound_effect(sfx_name: String):
	# Connect to AudioManager
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx(sfx_name)

## Get current story state
func get_story_state() -> Dictionary:
	if not story:
		return {}
	
	return {
		"can_continue": story.CanContinue,
		"has_choices": story.CurrentChoices.size() > 0,
		"current_choices": story.CurrentChoices,
		"variables": {}  # TODO: Get variables from story if available
	}

## Save story state
func save_state() -> String:
	if not story:
		return ""
	# TODO: Check GodotInk API for state saving
	return ""

## Load story state
func load_state(state_json: String):
	if not story:
		return
	# TODO: Check GodotInk API for state loading
