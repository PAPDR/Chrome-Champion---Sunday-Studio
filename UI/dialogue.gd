extends Control

var index : int = 0
@export var lines : Array = [""]
@export var text_speed : float = .03
var label = null
var complete_text = false

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Panel/Label
	startDialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Press to continue text
	#If the text is unfinished, finish the text
	#If it's finished, continue
	
	if Input.is_action_just_pressed("ui_accept"):
		#Check if it's complete
		if label.text == lines[index]:
			nextLine()
		else:
			#Stop the typeLine
			complete_text = true
			#Make text finish
			label.text = lines[index]
		pass
	

func startDialogue():
	index = 0
	nextLine()
	pass

func typeLine():
	for char in lines[index]:
		label.text = label.text + char
		await get_tree().create_timer(text_speed).timeout
		if complete_text:
			complete_text = false
			SignalBus.finished_dialogue.emit()
			break

func nextLine():
	if index < len(lines) - 1:
		#Increase index by 1, reset label
		index+=1
		label.text = ''
		
		#Start new typeLine
		typeLine()
	else:
		#End the process
		self.visible = false

#Adds dialogue lines
func add_lines(_lines: Array):
	lines = _lines
