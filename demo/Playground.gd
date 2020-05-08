extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	RTMidi.connect("midi_error", self, "_on_midi_error")
	RTMidi.connect("midi_log", self, "_on_midi_log")
	RTMidi.connect("midi_event", self, "_on_midi_event")
	
	print("RTMidi Version: " + RTMidi.get_version())
	
	print("Input Ports:")
	var ports = RTMidi.get_input_port_count()
	for i in range(ports):
		print("[" + str(i) + "] " + RTMidi.get_input_port_name(i))
		
	print("Output Ports:")
	ports = RTMidi.get_output_port_count()
	for i in range(ports):
		print("[" + str(i) + "] " + RTMidi.get_output_port_name(i))
	
	RTMidi.open_output_port(0)
	

func _on_midi_error(part, message):
	print("Plugin Error: " + part)
	print(message)

func _on_midi_log(part, message):
	print("Plugin Log: " + part)
	print(message)
	
func _on_midi_event(deltatime, message1, message2, message3):
	print("MidiEvent: " + str(message1) + "|" + str(message2) + "|" + str(message3))

func _on_Button_pressed():
	pass
	 
var on = false

func _on_Blink_pressed():
	on = !on
	if on:
		RTMidi.send_message(0x90,0x02,0x7F)
	else:
		RTMidi.send_message(0x90,0x02,0x0)
