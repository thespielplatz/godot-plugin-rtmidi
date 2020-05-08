tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("RTMidi", "res://addons/tsp-gp-rtmidi/RTMidi.gd")

func _exit_tree():
	remove_autoload_singleton("RTMidi")
