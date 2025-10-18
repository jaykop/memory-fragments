extends Control

# DialogueSystem - Handles dialogue display and progression
# Now integrated with InkManager for Ink-based stories

signal dialogue_started
signal dialogue_ended
signal choice_presented(choices: Array)

# UI References (set via node paths)
@onready var text_box: RichTextLabel = $DialogueBox/MarginContainer/VBoxContainer/TextBox
@onready var speaker_label: Label = $DialogueBox/MarginContainer/VBoxContainer/SpeakerLabel
@onready var choice_container: VBoxContainer = $ChoiceContainer

# State
var is_typing: bool = false
var text_speed: float = 0.05  # seconds per character

# Typing effect
var visible_characters: int = 0
var typing_timer: float = 0.0
var full_text: String = ""

# Ink integration
var using_ink: bool = false

func _ready():
	text_box.visible_characters = 0
	choice_container.visible = false
	
	# Connect to InkManager if it exists
	if has_node("/root/InkManager"):
		var ink_manager = get_node("/root/InkManager")
		ink_manager.line_displayed.connect(_on_ink_line_displayed)
		ink_manager.choice_presented.connect(_on_ink_choices_presented)
		using_ink = true
		print("DialogueSystem: Connected to InkManager")
	
func _process(delta):
	if is_typing:
		typing_timer += delta
		if typing_timer >= text_speed:
			typing_timer = 0.0
			visible_characters += 1
			text_box.visible_characters = visible_characters
			
			if visible_characters >= text_box.get_total_character_count():
				is_typing = false

## Start playing a chapter using InkManager
func start_chapter(chapter_id: String):
	if not using_ink:
		push_error("DialogueSystem: InkManager not available")
		return false
		
	var ink_manager = get_node("/root/InkManager")
	if ink_manager.load_chapter(chapter_id):
		dialogue_started.emit()
		advance_ink_story()
		return true
	return false

## Continue the Ink story
func advance_ink_story():
	if not using_ink:
		return
		
	var ink_manager = get_node("/root/InkManager")
	
	if is_typing:
		# Skip typing animation
		_complete_typing()
		return
	
	# Continue to next line
	if ink_manager.continue_story():
		# More content available, will be displayed via signal
		pass
	else:
		# No more content or choices are present
		var state = ink_manager.get_story_state()
		if not state.has_choices:
			dialogue_ended.emit()

## Handle line from InkManager
func _on_ink_line_displayed(line_type: String, speaker: String, text: String):
	match line_type:
		"character":
			_show_character_line(speaker, text)
		"thought":
			_show_thought(text)
		"narration":
			_show_narration(text)
		_:
			_show_narration(text)
	
	# Auto-advance for continuous story flow
	# Player can still click to skip typing
	
func _show_character_line(speaker: String, text: String):
	speaker_label.text = _format_speaker_name(speaker)
	speaker_label.visible = true
	_start_typing_effect(text)

func _show_thought(text: String):
	speaker_label.visible = false
	# Could add special formatting for thoughts
	_start_typing_effect("[i]" + text + "[/i]")

func _show_narration(text: String):
	speaker_label.visible = false
	_start_typing_effect(text)

func _format_speaker_name(speaker_id: String) -> String:
	# Map character IDs to display names
	var name_map = {
		"junhyuk": "이준혁",
		"minsoo": "최민수",
		"yujin": "강유진",
		"narrator": ""
	}
	return name_map.get(speaker_id, speaker_id.capitalize())

func _start_typing_effect(text: String):
	full_text = text
	text_box.text = text
	visible_characters = 0
	text_box.visible_characters = 0
	is_typing = true
	typing_timer = 0.0
	choice_container.visible = false

func _complete_typing():
	is_typing = false
	text_box.visible_characters = text_box.get_total_character_count()

## Handle choices from InkManager
func _on_ink_choices_presented(choices: Array):
	_show_ink_choices(choices)

func _show_ink_choices(choices: Array):
	# Clear existing choices
	for child in choice_container.get_children():
		child.queue_free()
	
	# Create choice buttons
	for i in range(choices.size()):
		var choice_text = choices[i]
		var button = Button.new()
		button.text = choice_text
		button.custom_minimum_size = Vector2(0, 50)
		button.pressed.connect(_on_ink_choice_selected.bind(i))
		choice_container.add_child(button)
	
	choice_container.visible = true
	choice_presented.emit(choices)

func _on_ink_choice_selected(choice_index: int):
	if not using_ink:
		return
	
	var ink_manager = get_node("/root/InkManager")
	ink_manager.make_choice(choice_index)
	choice_container.visible = false

## Legacy JSON dialogue support (fallback)
func load_dialogue_file(file_path: String) -> bool:
	"""Load dialogue from JSON file (legacy support)"""
	print("DialogueSystem: Using legacy JSON mode")
	using_ink = false
	
	if not FileAccess.file_exists(file_path):
		print("Dialogue file not found: %s" % file_path)
		return false
		
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		print("Failed to parse dialogue JSON: %s" % file_path)
		return false
	
	# Legacy implementation kept for compatibility
	# TODO: Migrate old dialogues to Ink format
	return false

func _input(event):
	"""Handle input for dialogue progression"""
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			if using_ink:
				advance_ink_story()
