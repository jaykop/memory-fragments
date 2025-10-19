extends Node

# Main scene controller

@onready var dialogue_system = $DialogueSystem

func _ready():
	print("Main scene ready")
	print("Godot version: ", Engine.get_version_info())
	
	# Connect dialogue signals
	dialogue_system.dialogue_ended.connect(_on_dialogue_ended)
	
	# Connect InkManager signals
	InkManager.clue_unlocked.connect(_on_clue_unlocked)
	InkManager.trust_changed.connect(_on_trust_changed)
	
	# Start the prologue with Ink
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue using Ink"""
	print("Starting Chapter 5...")
	
	# Load chapter using InkManager
	if InkManager.load_chapter("chapter_5"):
		print("Chapter 5 loaded successfully")
		# Start reading the story
		InkManager.continue_story()
	else:
		push_error("Failed to load Chapter 5")
		# Fallback to legacy dialogue
		_try_legacy_dialogue()

func _try_legacy_dialogue():
	"""Fallback to legacy JSON dialogue if Ink fails"""
	print("Attempting legacy dialogue system...")
	var dialogue_path = "res://data/dialogues/chapter_5/rooftop_01.json"
	if FileAccess.file_exists(dialogue_path):
		dialogue_system.load_dialogue_file(dialogue_path)
	else:
		push_error("No dialogue data available")
	
func _on_dialogue_ended():
	print("Dialogue ended - Prologue complete!")
	# TODO: Transition to memory connection phase

func _on_clue_unlocked(clue_id: String):
	print("Clue unlocked: ", clue_id)
	# TODO: Add to clue collection system

func _on_trust_changed(amount: int):
	print("Trust changed: ", amount)
	# TODO: Update trust meter UI
