extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$LibNode.connect("error", self, "_on_internal_plugin_error")
	$LibNode.connect("log", self, "_on_log")
	pass # Replace with function body.

func _on_internal_plugin_error(a, b):
	print("Plugin Error")
	print(b)

func _on_log(a, b):
	print("Log: " + str(b))

func _on_Button_pressed():
	print($LibNode.getVersion())
	var ports = $LibNode.getPortCount()
	for i in range(ports):
		print("[" + str(i) + "] " + $LibNode.getPortName(i))

func _on_Blink_pressed():
	$LibNode.sendMessage(0x90,0x02,0x7F)
	pass # Replace with function body.
