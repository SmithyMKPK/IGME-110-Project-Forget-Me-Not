extends Node
class_name Item

# Title has to be used because node HAS to already have a variable named name. Finna kms on golly.
var title: String
var icon: CompressedTexture2D

# Constructor
func _init(title: String, icon: CompressedTexture2D) -> void:
	self.title = title
	self.icon = icon
