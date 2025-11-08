extends Node
class_name Item

# Title has to be used because node HAS to already have a variable named name. Finna kms on golly.
var title: String
var description: String
var icon: Texture2D

# Constructor
func _init(title: String, description: String, icon: Texture2D) -> void:
	self.title = title
	self.description = description
	self.icon = icon
