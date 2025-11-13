extends Control

@export var map: TextureRect
@export var youScreen: Control
@export var yourStuffScreen: Control
@export var statsScreen: Control
@export var yourGardenScreen: Control

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

# When the scene first opens, it'll load each item that the person has and puts it at a random point on the map
func _on_visibility_changed() -> void:
	if self.visible:
		simulateItem()

func simulateItem():
	var mapSize = map.size
	
	# Clears all of the items to ensure that excess items dont exist
	for textureRect in map.get_children():
		if textureRect is TextureRect:
			textureRect.queue_free()
	
	for item in get_parent().currentUser.registeredItems:
		# Grabs a random color to make the colorRect and gives it's tooltip text the name of the item
		var itemIcon: TextureRect = TextureRect.new()
		itemIcon.texture = item.icon
		itemIcon.tooltip_text = item.title
		
		# Slaps the item onto a random point on the map
		map.add_child(itemIcon)
		itemIcon._set_position(Vector2(RNG.randi_range(0, mapSize.x), RNG.randi_range(0, mapSize.y)))

# Methods that act on their respective buttons being pressed. It'll take the user to their respective screens.
func _on_enter_garden_button_pressed() -> void:
	self.visible = false
	yourGardenScreen.visible = true
func _on_your_profile_button_pressed() -> void:
	self.visible = false
	youScreen.visible = true
func _on_your_items_button_pressed() -> void:
	self.visible = false
	yourStuffScreen.visible = true
func _on_stats_button_pressed() -> void:
	self.visible = false
	statsScreen.visible = true
