extends Node

# Main scene controller

func _ready():
	print("Main scene ready")
	print("Godot version: ", Engine.get_version_info())
	
	# Check Dialogic
	if not Engine.has_singleton("Dialogic"):
		push_error("❌ Dialogic not available!")
		return
	
	# Connect Dialogic signals
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	print("✅ Dialogic connected")
	
	# Small delay
	await get_tree().create_timer(0.2).timeout
	
	# Start the prologue
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue"""
	print("📖 Starting Chapter 5: Awakening")
	
	# Use Dialogic properly with layout scene
	Dialogic.start("res://dialogic/timelines/chapter_5_awakening.dtl")
	print("✅ Timeline started")
		
func _on_timeline_ended():
	print("✅ Chapter 5 Awakening complete!")
	# TODO: Transition to next scene

func _on_dialogic_signal(argument: String):
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
