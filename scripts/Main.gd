extends Node

# Main scene controller

@onready var dialogue_system = $DialogueSystem

func _ready():
	print("Main scene ready")
	
	# Connect dialogue signals
	dialogue_system.dialogue_ended.connect(_on_dialogue_ended)
	
	# Start the prologue
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue"""
	var dialogue_path = "res://data/dialogues/chapter_5/rooftop_01.json"
	dialogue_system.load_dialogue_file(dialogue_path)
	
func _on_dialogue_ended():
	print("Dialogue ended - Prologue complete!")
	# TODO: Transition to memory connection phase
