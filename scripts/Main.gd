extends Node

# Main scene controller

@onready var dialogue_player = $DialoguePlayer

func _ready():
	print("Main scene ready")
	print("Godot version: ", Engine.get_version_info())
	
	# Connect dialogue player signals
	dialogue_player.dialogue_ended.connect(_on_dialogue_ended)
	dialogue_player.signal_received.connect(_on_signal_received)
	
	# Small delay to let scene fully load
	await get_tree().create_timer(0.1).timeout
	
	# Start the prologue
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue"""
	print("📖 Starting Chapter 5: Awakening")
	
	var success = dialogue_player.start_timeline("res://dialogic/timelines/chapter_5_awakening.dtl")
	if success:
		print("✅ Timeline started")
	else:
		push_error("❌ Failed to start timeline")
		
func _on_dialogue_ended():
	print("✅ Chapter 5 Awakening complete!")
	# TODO: Transition to next scene

func _on_signal_received(argument: String):
	"""Handle custom signals from timeline"""
	print("📡 Signal received: ", argument)
	
	var parts = argument.split(":", true, 1)
	if parts.size() < 2:
		return
	
	match parts[0]:
		"unlock_clue":
			_on_clue_unlocked(parts[1])
		"trust_change":
			_on_trust_changed(int(parts[1]))
		"chapter_complete":
			_on_chapter_complete(parts[1])

func _on_clue_unlocked(clue_id: String):
	print("🔍 Clue unlocked: ", clue_id)
	# TODO: Add to clue collection system

func _on_trust_changed(amount: int):
	print("💭 Trust changed: ", amount)
	# TODO: Update trust meter UI

func _on_chapter_complete(chapter_id: String):
	print("🎬 Chapter complete: ", chapter_id)
	# TODO: Save progress, show chapter summary
