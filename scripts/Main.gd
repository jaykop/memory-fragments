extends Node

# Main scene controller

func _ready():
	print("Main scene ready")
	print("Godot version: ", Engine.get_version_info())
	
	# Connect Dialogic signals
	if Engine.has_singleton("Dialogic"):
		Dialogic.signal_event.connect(_on_dialogic_signal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		print("✅ Dialogic connected")
	else:
		push_error("❌ Dialogic not available!")
		return
	
	# Small delay to let scene fully load
	await get_tree().create_timer(0.1).timeout
	
	# Start the prologue
	start_prologue()
	
func start_prologue():
	"""Start Chapter 5 prologue"""
	print("Starting Chapter 5...")
	
	# Start Chapter 5 with Dialogic
	# Dialogic.start() creates its own UI automatically
	if Engine.has_singleton("Dialogic"):
		print("📖 Starting Chapter 5: Awakening")
		var layout = Dialogic.start("res://dialogic/timelines/chapter_5_awakening.dtl")
		
		if layout:
			print("✅ Dialogic layout created")
			# Add layout to scene tree if needed
			if not layout.is_inside_tree():
				add_child(layout)
		else:
			push_error("Failed to create Dialogic layout")
	else:
		push_error("Dialogic not available!")
		print("⚠️ Enable Dialogic plugin in Project Settings")
		
func _on_timeline_ended():
	print("✅ Timeline ended - Chapter 5 Awakening complete!")
	# TODO: Transition to next scene

func _on_dialogic_signal(argument: String):
	"""Handle custom signals from Dialogic timeline"""
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
