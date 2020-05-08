extends Node

var rtmidi;

signal on_midi_error(part, message)
signal on_midi_log(part, message)
signal midi_event(deltatime, message1, message2, message3)

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
	rtmidi.openInputPort(0)
	
func close_input_port(i):
	rtmidi.closeInputPort(0)
	
func get_output_port_count():
	return rtmidi.getOutputPortCount()
	
func get_output_port_name(i):
	return rtmidi.getOutputPortName(i)
	
func open_output_port(i):
	rtmidi.openOutputPort(0)
	
func close_output_port(i):
	rtmidi.closeOutputPort(0)
	
func _on_midi_error(part, message):
	emit_signal("on_midi_error", part, message)

func _on_midi_log(part, message):
	emit_signal("on_midi_log", part, message)
	
func _midi_event(deltatime, message1, message2, message3):
	emit_signal("midi_event", deltatime, message1, message2, message3)

func send_message(m1, m2, m3):
	rtmidi.sendMessage(m1, m2, m3)
