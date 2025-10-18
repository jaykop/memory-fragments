extends Control

# DialogueSystem - Handles dialogue display and progression

signal dialogue_started
signal dialogue_ended
signal choice_presented(choices: Array)

# UI References (set via node paths)
@onready var text_box: RichTextLabel = $DialogueBox/MarginContainer/VBoxContainer/TextBox
@onready var speaker_label: Label = $DialogueBox/MarginContainer/VBoxContainer/SpeakerLabel
@onready var choice_container: VBoxContainer = $ChoiceContainer

# State
var current_dialogue: Dictionary = {}
var dialogue_queue: Array = []
var current_index: int = 0
var is_typing: bool = false
var text_speed: float = 0.05  # seconds per character

# Typing effect
var visible_characters: int = 0
var typing_timer: float = 0.0

func _ready():
	text_box.visible_characters = 0
	choice_container.visible = false
	
func _process(delta):
	if is_typing:
		typing_timer += delta
		if typing_timer >= text_speed:
			typing_timer = 0.0
			visible_characters += 1
			text_box.visible_characters = visible_characters
			
			if visible_characters >= text_box.get_total_character_count():
				is_typing = false
				
func load_dialogue_file(file_path: String) -> bool:
	"""Load dialogue from JSON file"""
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
		
	current_dialogue = json.data
	dialogue_queue = current_dialogue.get("dialogues", [])
	current_index = 0
	
	emit_signal("dialogue_started")
	show_current_dialogue()
	return true
	
func show_current_dialogue():
	"""Display current dialogue entry"""
	if current_index >= dialogue_queue.size():
		emit_signal("dialogue_ended")
		return
		
	var entry = dialogue_queue[current_index]
	var entry_type = entry.get("type", "dialogue")
	
	if entry_type == "choice":
		show_choices(entry)
	else:
		show_text(entry)
		
func show_text(entry: Dictionary):
	"""Display text dialogue"""
	var speaker = entry.get("speaker", "")
	var text = entry.get("text", "")
	
	# Set speaker name
	if speaker == "narrator":
		speaker_label.text = ""
		speaker_label.visible = false
	else:
		speaker_label.text = speaker.capitalize()
		speaker_label.visible = true
		
	# Start typing effect
	text_box.text = text
	visible_characters = 0
	text_box.visible_characters = 0
	is_typing = true
	typing_timer = 0.0
	
	# Hide choices
	choice_container.visible = false
	
func show_choices(entry: Dictionary):
	"""Display choice options"""
	var choices = entry.get("choices", [])
	
	# Clear existing choices
	for child in choice_container.get_children():
		child.queue_free()
		
	# Create choice buttons
	for i in range(choices.size()):
		var choice = choices[i]
		var button = Button.new()
		button.text = choice.get("text", "")
		button.custom_minimum_size = Vector2(0, 50)
		button.pressed.connect(_on_choice_selected.bind(i))
		choice_container.add_child(button)
		
	choice_container.visible = true
	emit_signal("choice_presented", choices)
	
func _on_choice_selected(choice_index: int):
	"""Handle choice selection"""
	var entry = dialogue_queue[current_index]
	var choices = entry.get("choices", [])
	
	if choice_index < choices.size():
		var choice = choices[choice_index]
		var next_id = choice.get("next", -1)
		var trust_change = choice.get("trust_change", 0)
		
		# Apply trust change if GameManager exists
		if trust_change != 0:
			print("Trust change: %d" % trust_change)
			# TODO: Apply to trust system when implemented
			
		# Move to next dialogue
		if next_id != -1:
			# Find dialogue with matching ID
			for i in range(dialogue_queue.size()):
				if dialogue_queue[i].get("id", -1) == next_id:
					current_index = i
					show_current_dialogue()
					return
					
	# If no valid next, end dialogue
	emit_signal("dialogue_ended")
	
func advance_dialogue():
	"""Move to next dialogue entry"""
	if is_typing:
		# Skip typing animation
		is_typing = false
		text_box.visible_characters = text_box.get_total_character_count()
		return
		
	var entry = dialogue_queue[current_index]
	var next_id = entry.get("next", -1)
	
	if next_id == -1 or entry.get("type") == "choice":
		# No automatic progression for choices or end
		return
		
	# Find next dialogue
	for i in range(dialogue_queue.size()):
		if dialogue_queue[i].get("id", -1) == next_id:
			current_index = i
			show_current_dialogue()
			return
			
	# If no next found, end dialogue
	emit_signal("dialogue_ended")
	
func _input(event):
	"""Handle input for dialogue progression"""
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			advance_dialogue()
