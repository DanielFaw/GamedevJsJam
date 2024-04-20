extends Node


var nodes := {}

func add_resource(node : Node, name : String) -> void:
	nodes[name] = node
	pass

func get_resource(name : String) -> Node:
	return nodes[name]
