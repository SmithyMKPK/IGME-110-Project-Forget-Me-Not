extends Node
class_name UserData

var username: String = ""
var password: String = ""
var registeredItems: Array[Item]

# Partially parameterized constructor that gets the user's username and password, and as a default, has no registered
# items
func _init(username: String, password: String) -> void:
	self.username = username
	self.password = password
	self.registeredItems = []
