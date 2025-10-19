extends Control

## SimpleDialoguePlayer - Parse and display .dtl files directly

signal dialogue_ended
signal signal_received(arg: String)

@onready var text_box = $DialogueBox/MarginContainer/TextLabel

var lines: Array = []
var current_index: int = 0
var is_playing: bool = false

func _ready():
	hide_dialogue_box()

func start_timeline(path: String):
	"""Load and start a timeline file"""
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Cannot open timeline: " + path)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	lines = content.split("\n")
	current_index = 0
	is_playing = true
	
	show_dialogue_box()
	show_next_line()
	return true

func show_dialogue_box():
	$DialogueBox.show()

func hide_dialogue_box():
	$DialogueBox.hide()

func show_next_line():
	"""Display next line from timeline"""
	while current_index < lines.size():
		var line = lines[current_index].strip_edges()
		current_index += 1
		
		# Skip empty lines
		if line.is_empty():
			continue
		
		# Handle wait command
		if line.begins_with("[wait time="):
			var time_str = line.get_slice('"', 1)
			var wait_time = float(time_str)
			await get_tree().create_timer(wait_time).timeout
			continue
		
		# Handle signal command
		if line.begins_with("[signal arg="):
			var arg = line.get_slice('"', 1)
			signal_received.emit(arg)
			print("📡 Signal: ", arg)
			continue
		
		# Handle color tags - convert to BBCode
		if "[color=" in line:
			text_box.text = line
			return
		
		# Regular text
		text_box.text = line
		return
	
	# End of timeline
	end_timeline()

func end_timeline():
	is_playing = false
	hide_dialogue_box()
	dialogue_ended.emit()
	print("✅ Timeline complete")

func _input(event):
	"""Progress dialogue on input"""
	if not is_playing:
		return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			show_next_line()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			show_next_line()
			get_viewport().set_input_as_handled()
