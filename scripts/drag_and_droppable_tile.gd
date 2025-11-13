extends TextureRect

enum FlowerTypes{
	Blue,
	Red,
	Smexy,
	None
}

signal dropped_flower()

@export var hasItem: bool = false
@export var isSeedHolder: bool
@export var seedHolderType: FlowerTypes
@export var seedCountLabel: Label
var currentFlowerType: FlowerTypes = FlowerTypes.None

# Method that reacts to when the user begins dragging an item. It sets a preview to show the user what they're doing
func _get_drag_data(_at_position: Vector2) -> Variant:
	# If the seed count is less than 1, then the user shouldn't be able to place down any seds.
	if isSeedHolder && seedCountLabel.text.to_int() < 1:
		return
	
	set_drag_preview(get_preview())
	
	return self

# Method that checks whether it's valid for an item to be dropped in a position. 
# It checks whether the data coming through is a texture rect, but it'll also check whether the current
# tile doesn't already have something on it.
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect && self.hasItem == false && isSeedHolder == false

# Method that creates the preview texture and preview control node for the user to see exactly what they're doing
func get_preview() -> Control:
	var previewTexture = TextureRect.new()
	var preview = Control.new()
	
	previewTexture.texture = self.texture
	previewTexture.expand_mode = 1
	previewTexture.size = Vector2(84, 66)
	previewTexture.position = Vector2() # Used to ensure that the texture is centered with the mouse
	
	preview.add_child(previewTexture)
	
	return preview

# Method that acts on the player dropping an item. Once it's done, it replaces the texture of the current (this object)
# texture rect to the texture, and what was previously the owner of it's texture to nothing,
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var currentTexture = self.texture
	
	self.texture = data.texture
	self.hasItem = true
	self.currentFlowerType = data.seedHolderType
	
	if !data.isSeedHolder:
		data.texture = currentTexture
		data.hasItem = false
	else:
		data.emit_signal("dropped_flower")

# Method that sets the flower texture whever it's being updated or it's initially loaded
func setFlowerTexture(flowerTypeAsInt: int) -> void:
	match flowerTypeAsInt:
		0:
			self.texture = load("res://assets/spritesheet_stuffs/blue_flower.tres")
			self.hasItem = true
		1:
			self.texture = load("res://assets/spritesheet_stuffs/red_flower.tres")
			self.hasItem = true
		2:
			self.texture = load("res://assets/spritesheet_stuffs/smexy_flower.tres")
			self.hasItem = true
		_:
			self.texture = null
