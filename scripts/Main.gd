extends Node

# Main scene controller

@onready var dialogue_system = $DialogueSystem

func _ready():
	print("Main scene ready")
	print("Godot version: ", Engine.get_version_info())
	
	# Connect dialogue signals
	dialogue_system.dialogue_ended.connect(_on_dialogue_ended)
	
	# Connect Dialogic signals (if using Dialogic)
	if Engine.has_singleton("Dialogic"):
		Dialogic.signal_event.connect(_on_dialogic_signal)
		Dialogic.timeline_ended.connect(_on_dialogue_ended)
	
	# Start the prologue
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue"""
	print("Starting Chapter 5...")
	
	# TODO: Uncomment when Dialogic timeline is ready
	# if dialogue_system.start_chapter("5"):
	# 	print("Chapter 5 started with Dialogic")
	# else:
	# 	push_error("Failed to start Chapter 5")
	
	# Temporary: Show placeholder
	print("⚠️ Chapter 5 timeline not yet created")
	print("📝 Next step: Create timeline in Dialogic editor")
		
func _on_dialogue_ended():
	print("Dialogue ended - Prologue complete!")
	# TODO: Transition to memory connection phase

func _on_dialogic_signal(argument: String):
	"""Handle custom signals from Dialogic timeline"""
	var parts = argument.split(":", true, 1)
	if parts.size() < 2:
		return
	
	match parts[0]:
		"unlock_clue":
			_on_clue_unlocked(parts[1])
		"trust_change":
			_on_trust_changed(int(parts[1]))

func _on_clue_unlocked(clue_id: String):
	print("Clue unlocked: ", clue_id)
	# TODO: Add to clue collection system

func _on_trust_changed(amount: int):
	print("Trust changed: ", amount)
	# TODO: Update trust meter UI
