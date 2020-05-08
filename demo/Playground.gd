extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$LibNode.connect("error", self, "_on_midi_error")
	$LibNode.connect("log", self, "_on_midi_log")
	$LibNode.connect("midi_in_callback", self, "_midi_event")
	
	print("RTMidi Version: " + $LibNode.getVersion())
	
	print("Input Ports:")
	var ports = $LibNode.getInputPortCount()
	for i in range(ports):
		print("[" + str(i) + "] " + $LibNode.getInputPortName(i))
		
	print("Output Ports:")
	ports = $LibNode.getOutputPortCount()
	for i in range(ports):
		print("[" + str(i) + "] " + $LibNode.getOutputPortName(i))
	
	$LibNode.openOutputPort(0)
	

func _on_midi_error(part, message):
	print("Plugin Error: " + part)
	print(message)

func _on_midi_log(part, message):
	print("Plugin Log: " + part)
	print(message)
	
func _midi_event(deltatime, message1, message2, message3):
	print("MidiEvent: " + str(message1) + "|" + str(message2) + "|" + str(message3))

func _on_Button_pressed():
	pass
	 
var on = false

func _on_Blink_pressed():
	on = !on
	if on:
		$LibNode.sendMessage(0x90,0x02,0x7F)
	else:
		$LibNode.sendMessage(0x90,0x02,0x0)
