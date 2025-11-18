extends Control

enum PopupType{
	Information,
	Shop
}

@export var flowerContainer: GridContainer
@export var shopGrid: GridContainer
@export var blueFlowerContainer:VBoxContainer
@export var redFlowerContainer: VBoxContainer
@export var smexyFlowerContainer: VBoxContainer
@export var redFlowerTexture: TextureRect
@export var blueFlowerTexture: TextureRect
@export var smexyFlowerTexture: TextureRect
@export var popupUI: Panel
@export var yourSeedsPopup: Panel
@export var titleText: Label
@export var infoLabel: Label
@export var coinCounter: Label

var popupType: PopupType

const SCREEN_CONFIG: Dictionary = {
	PopupType.Information: 
		{
		"label_text": "INFORMATION",
		"info_label_visible": true,
		"shop_grid_visible": false,
		"coin_counter_visible": false
		},
	PopupType.Shop: 
		{
		"label_text": "SHOP",
		"info_label_visible": false,
		"shop_grid_visible": true,
		"coin_counter_visible": true
		},
}

# Method that acts on the screen changing visibility. Once it's visible, it'll deploy each texturerect
func _on_visibility_changed() -> void:
	if visible:
		if !get_parent().currentUser.createdGarden:
			buildGarden()
		else:
			rebuildGarden()
		getSeedCount()
	else:
		removeChildren()
		popupUI.visible = false

# Gets called upon the first time the user opens the garden for the first time
func buildGarden() -> void:
	for flower in range(88):
		var dragAndDropTileScene: TextureRect = load("res://scenes/drag_and_droppable_tile.tscn").instantiate()
		
		# Gets and sets the texture of the texture rec
		dragAndDropTileScene.setFlowerTexture(4)
		
		# Adds the flower to the scene tree under the flower container while also adding it to the user's flower layout.
		# Also sets the index of the scene so it's possible to get the information
		flowerContainer.add_child(dragAndDropTileScene)
		get_parent().currentUser.flowerLayout.append(dragAndDropTileScene)
	get_parent().currentUser.createdGarden = true

func buildPopup() -> void:
	var config = SCREEN_CONFIG.get(popupType)
	
	titleText.text = config["label_text"]
	infoLabel.visible = config["info_label_visible"]
	shopGrid.visible = config["shop_grid_visible"]
	coinCounter.visible = config["coin_counter_visible"]

# Method that updates the coin counter
func updateCoinCounter():
	coinCounter.text = str(get_parent().currentUser.gardenGelt)

# Method that rebuilds the garden based on the user's older inputs
func rebuildGarden():
	for flower in get_parent().currentUser.flowerLayout:
		flowerContainer.add_child(flower)

# Method that removes each child from the tree, but not as an object
func removeChildren() -> void:
	# Removes what could possibly be another user's flower layout
	for child in flowerContainer.get_children():
		flowerContainer.remove_child(child)

# Method that will make the buttons not disabled if the user has enough money
func checkMoneyStatus() -> void:
	for container in [blueFlowerContainer, redFlowerContainer, 
	smexyFlowerContainer]:
		var button: Button = container.find_child("Buy Button")
		button.disabled = get_parent().currentUser.gardenGelt < 50

# Method that counts the number of each seed is in the user's inventory and sets the seed counter to the number
func getSeedCount() -> void:
	var seedCounter: Label
	var redFlowerCount: int = 0
	var blueFlowerCount: int = 0
	var smexyFlowerCount: int = 0
	
	for flower in get_parent().currentUser.seedInventory:
		if flower == get_parent().currentUser.FlowerTypes.Red:
			redFlowerCount += 1
		elif flower == get_parent().currentUser.FlowerTypes.Blue:
			blueFlowerCount += 1
		else: 
			smexyFlowerCount += 1
	
	redFlowerTexture.find_child("Seed Counter").text = str(redFlowerCount)
	blueFlowerTexture.find_child("Seed Counter").text = str(blueFlowerCount)
	smexyFlowerTexture.find_child("Seed Counter").text = str(smexyFlowerCount)

# Methods that acts on the information button being pressed. It'll open the popup UI with each respective nodes and vales
func _on_information_button_pressed() -> void:
	popupUI.visible = true
	popupType = PopupType.Information
	buildPopup()
func _on_shop_button_pressed() -> void:
	popupUI.visible = true
	popupType = PopupType.Shop
	buildPopup()
	checkMoneyStatus()
	updateCoinCounter()

# Method that reacts to the exit button being pressed in the popup. It'll close everything in the popup UI box
func _on_exit_button_pressed() -> void:
	popupUI.visible = false

# Method that acts on the bag of seeds button being pressed. It'll bring up a tiny screen 
func _on_bag_of_seeds_button_toggled(toggled_on: bool) -> void:
	var tween: Tween = create_tween()
	
	if toggled_on:
		yourSeedsPopup.visible = true
		tween.tween_property(yourSeedsPopup, "position", Vector2(0, yourSeedsPopup.get_screen_position().y - 100), 0.5)
	else:
		tween.tween_property(yourSeedsPopup, "position", Vector2(0, yourSeedsPopup.get_screen_position().y + 100), 0.5)
		yourSeedsPopup.visible = false

# Method that acts oon the buy button being pressed. It'll add the respective flower into the user's inventory
# to allow them to place a flower.
func _on_buy_button_pressed(typeOfFlower: String) -> void:
	match typeOfFlower:
		"Red":
			get_parent().currentUser.seedInventory.append(get_parent().currentUser.FlowerTypes.Red)
		"Blue":
			get_parent().currentUser.seedInventory.append(get_parent().currentUser.FlowerTypes.Blue)
		"Smexy":
			get_parent().currentUser.seedInventory.append(get_parent().currentUser.FlowerTypes.Smexy)
	getSeedCount()
	updateCoinCounter()

# Methods that acts on their respective seeds being placed down. It'll remove an instance from it in the user's
# inventory and then update the seed counters.
func _on_red_flower_holder_dropped_flower() -> void:
	get_parent().currentUser.seedInventory.erase(get_parent().currentUser.FlowerTypes.Red)
	getSeedCount()
func _on_blue_flower_holder_dropped_flower() -> void:
	get_parent().currentUser.seedInventory.erase(get_parent().currentUser.FlowerTypes.Blue)
	getSeedCount()
func _on_smexy_flower_holder_dropped_flower() -> void:
	get_parent().currentUser.seedInventory.erase(get_parent().currentUser.FlowerTypes.Smexy)
	getSeedCount()
