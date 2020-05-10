extends Node

var rtmidi;

const NOTE_OFF = 0
const NOTE_ON = 1
const POLYPHONIC_KEY_PREASSURE = 2
const CONTROL_CHANGE = 3
const PROGRAM_CHANGE = 4
const CHANNEL_PREASURE = 5
const PITCH_PEND_CHANGE = 6

signal midi_error(part, message)
signal midi_log(part, message)
signal midi_event_raw(deltatime, message1, message2, message3)
signal midi_event(deltatime, input_event_midi)

func _ready():
	rtmidi = Node.new()
	rtmidi.set_script(load("res://addons/tsp-gp-rtmidi/bin/gdrtmidi.gdns"))
	add_child(rtmidi)

	rtmidi.connect("error", self, "_on_midi_error")
	rtmidi.connect("log", self, "_on_midi_log")
	rtmidi.connect("midi_in_callback", self, "_midi_event")

func get_version():
	return rtmidi.getVersion()
	
func get_input_port_count():
	return rtmidi.getInputPortCount()
	
func get_input_port_name(i):
	return rtmidi.getInputPortName(i)

func open_input_port(i):
	rtmidi.openInputPort(i)
	
func close_input_port():
	rtmidi.closeInputPort()
	
func get_output_port_count():
	return rtmidi.getOutputPortCount()
	
func get_output_port_name(i):
	return rtmidi.getOutputPortName(i)
	
func open_output_port(i):
	rtmidi.openOutputPort(i)
	
func close_output_port():
	rtmidi.closeOutputPort()
	
func _on_midi_error(part, message):
	emit_signal("on_midi_error", part, message)

func _on_midi_log(part, message):
	emit_signal("on_midi_log", part, message)
	
func _midi_event(deltatime, message1, message2, message3):
	var event = convert_to_inputeventmidi(message1, message2, message3)
	
	emit_signal("midi_event_raw", deltatime, message1, message2, message3)
	emit_signal("midi_event", deltatime, event)

func send_message(m1, m2, m3):
	rtmidi.sendMessage(m1, m2, m3)
	
func convert_to_inputeventmidi(message1, message2, message3)->InputEventMIDI:
	var e = InputEventMIDI.new()
	e.channel = message1 % 16 + 1
	e.message = message1 / 16 - 8
	e.pitch = message2
	e.velocity = message3
	
	match e.message:
		NOTE_OFF, NOTE_ON, POLYPHONIC_KEY_PREASSURE:
			pass
		CONTROL_CHANGE:
			e.pitch = 0
			e.velocity = 0
			e.controller_number = message2
			e.controller_value = message3
			pass
		PROGRAM_CHANGE:
			pass
		CHANNEL_PREASURE:
			pass
		PITCH_PEND_CHANGE:
			pass
	#print("Channel:" + str(e.channel) + " Message:" + str(e.message)  + " Pitch:" + str(e.pitch) + " Velocity:" + str(e.velocity)+ " controller_number:" + str(e.controller_number) + " controller_number:" + str(e.controller_value))
	return e

func dec2bin(var decimal_value, check := 8):
	check -= 1
	var binary_string = "" 
	var temp 
	while(check >= 0):
		temp = decimal_value >> check 
		if(temp & 1):
			binary_string = binary_string + "1"
		else:
			binary_string = binary_string + "0"
		check -= 1
	print(binary_string)
