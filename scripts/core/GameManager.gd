extends Node

# GameManager - Central game state management

signal chapter_changed(chapter: int)
signal scene_changed(scene_name: String)

# Game state
var current_chapter: int = 5  # Start at Chapter 5 (ending)
var current_scene: String = ""
var story_flags: Dictionary = {}

# Systems
var trust_system: Node = null
var clue_inventory: Node = null
var dialogue_system: Node = null

func _ready():
	print("GameManager initialized")
	
func start_game():
	"""Start a new game from Chapter 5"""
	current_chapter = 5
	current_scene = "rooftop_01"
	story_flags.clear()
	
	emit_signal("chapter_changed", current_chapter)
	emit_signal("scene_changed", current_scene)
	
func load_scene(scene_name: String):
	"""Load a new scene"""
	current_scene = scene_name
	emit_signal("scene_changed", scene_name)
	
func set_flag(flag_name: String, value):
	"""Set a story flag"""
	story_flags[flag_name] = value
	print("Flag set: %s = %s" % [flag_name, value])
	
func get_flag(flag_name: String, default = null):
	"""Get a story flag"""
	return story_flags.get(flag_name, default)
	
func change_chapter(chapter: int):
	"""Change to a different chapter"""
	current_chapter = chapter
	emit_signal("chapter_changed", chapter)
	print("Changed to Chapter %d" % chapter)
