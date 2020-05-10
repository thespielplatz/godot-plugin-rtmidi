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
	RTMidi.open_input_port(1)
	

func _on_midi_error(part, message):
	print("Plugin Error: " + part)
	print(message)

func _on_midi_log(part, message):
	print("Plugin Log: " + part)
	print(message)
	
func _on_midi_event(deltatime, event: InputEventMIDI):
	if event.message == RTMidi.CONTROL_CHANGE:
		print("Channel:" + str(event.channel) + " Message:" + str(event.message) + " controller_number:" + str(event.controller_number) + " controller_number:" + str(event.controller_value))
	else:
		print("Channel:" + str(event.channel) + " Message:" + str(event.message) + " Pitch:" + str(event.pitch) + " Velocity:" + str(event.velocity))
	#print("MidiEvent: " + str(message1) + "|" + str(message2) + "|" + str(message3))

func _on_Button_pressed():
	pass
	 
var on = false

func _on_Blink_pressed():
	on = !on
	if on:
		RTMidi.send_message(0x90,0x02,0x7F)
	else:
		RTMidi.send_message(0x90,0x02,0x0)
