extends Control

enum HUDTypes
{
	Create_Item,
	Edit_Item_Name,
	Edit_Item_Icon
}

@export var itemsContainer: VBoxContainer
@export var iconScroller: ScrollContainer
@export var userHUD: Panel
@export var HUDTitle: Label
@export var itemNameHeader: Label
@export var itemIconHeader: Label
@export var selectedItemHeader: Label
@export var errorLabel: Label
@export var selectedIconImage: TextureRect
@export var nameSelector: LineEdit
@export var confirmButton: Button

const SCREEN_CONFIG: Dictionary = {
	HUDTypes.Create_Item: 
		{
		"title_text": "NEW ITEM",
		"item_name_label_visible": true,
		"name_selector_visible": true,
		"item_icon_label_visible": true,
		"icon_scroller_visible": true,
		"selected_icon_label_visible": true,
		"selected_icon_texture_visible": true,
		"confirm_button_text": "CREATE"
		},
	HUDTypes.Edit_Item_Name: 
		{
		"title_text": "EDIT ITEM NAME",
		"item_name_label_visible": true,
		"name_selector_visible": true,
		"item_icon_label_visible": false,
		"icon_scroller_visible": false,
		"selected_icon_label_visible": false,
		"selected_icon_texture_visible": false,
		"confirm_button_text": "EDIT"
		},
	HUDTypes.Edit_Item_Icon: 
		{
		"title_text": "NEW ITEM ICON",
		"item_name_label_visible": false,
		"name_selector_visible": false,
		"item_icon_label_visible": true,
		"icon_scroller_visible": true,
		"selected_icon_label_visible": true,
		"selected_icon_texture_visible": true,
		"confirm_button_text": "EDIT"
		}
}

var requestedScreenType: HUDTypes
var userRequestedItem: Item = null
var selectedIconIndex: int = -1

# Method that acts upon the visibility of the node changing. Whenever it's visible, it'll rebuild the 
# current items the user had
func _on_visibility_changed() -> void:
	if self.visible:
		buildItemPanel()

# Method that gathers each of the necessary components to create an interactive panel for the user to interact with
func buildItemPanel() -> void:
	# Before starting anything, removes the current set of panels on the list to avoid stacking over and over again
	removeExcessChildren()
	
	for item in get_parent().currentUser.registeredItems:
		# Prepares all the necessary nodes that need to happen
		var panel: Panel = buildPanel()
		var hboxContainer: HBoxContainer = buildHBoxContainer()
		var textureRect: TextureRect = buildTextureRect(item)
		var label: Label = buildNameLabel(item)
		var vboxContainer: VBoxContainer = buildInnerVBoxContainer()
		var editIconButton: Button = buildEditItemIconButtonBuilder(item)
		var editNameButton: Button = buildEditItemNameButtonBuilder(item)
		var deleteItemButton: Button = buildDeleteButton(item)
		
		# Begins adding the nodes to one another 
		panel.add_child(hboxContainer)
		hboxContainer.add_child(textureRect)
		hboxContainer.add_child(label)
		hboxContainer.add_child(vboxContainer)
		hboxContainer.add_child(deleteItemButton)
		vboxContainer.add_child(editIconButton)
		vboxContainer.add_child(editNameButton)
		
		# Ensures that the hbox container is centered with the main panel
		hboxContainer.position = Vector2(31, 16)
		
		# After all is said and done, adds the panel to the items container
		itemsContainer.add_child(panel)

# Helper Methods
func buildPanel() -> Panel:
	var panel: Panel = Panel.new()
	var newStyleBox: StyleBoxTexture = StyleBoxTexture.new()
	
	newStyleBox.texture = load("res://assets/spritesheet_stuffs/big_panel.tres")
	panel.custom_minimum_size = Vector2(688, 175)
	
	panel.add_theme_stylebox_override("panel", newStyleBox)
	return panel
func buildHBoxContainer() -> HBoxContainer:
	var hboxcontainer: HBoxContainer = HBoxContainer.new()
	hboxcontainer.size = Vector2(600, 100)
	
	return hboxcontainer
func buildTextureRect(requestedItem: Item) -> TextureRect:
	var textureRect: TextureRect = TextureRect.new()
	textureRect.texture = requestedItem.icon
	textureRect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	textureRect.custom_minimum_size = Vector2(128, 128)
	
	return textureRect
func buildNameLabel(requestedItem: Item) -> Label:
	var label: Label = Label.new()
	label.text = requestedItem.title
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 30)
	return label
func buildInnerVBoxContainer() -> VBoxContainer:
	var vboxcontainer: VBoxContainer = VBoxContainer.new()
	vboxcontainer.alignment = BoxContainer.ALIGNMENT_CENTER
	
	return vboxcontainer
func buildEditItemIconButtonBuilder(requestedItem: Item) -> Button:
	var button: Button = Button.new()
	button.text = "Change Item Icon"
	button.add_theme_font_size_override("font", 25)
	button.pressed.connect(func(): _on_edit_item_icon_button_pressed(requestedItem))
	
	return button
func buildEditItemNameButtonBuilder(requestedItem: Item) -> Button:
	var button: Button = Button.new()
	button.text = "Change Item Name"
	button.add_theme_font_size_override("font", 25)
	button.pressed.connect(func(): _on_edit_item_name_button_pressed(requestedItem))
	
	return button
func buildDeleteButton(requestedItem: Item) -> Button:
	var button: Button = Button.new()
	button.text = "Delete Current Item"
	button.add_theme_font_size_override("font", 25)
	button.pressed.connect(func(): _on_delete_item_button_pressed(requestedItem))
	
	return button

# Method that removes the extra panels from the items container
func removeExcessChildren() -> void:
	for child in itemsContainer.get_children():
		if child is Button || child is Label:
			continue
		child.queue_free()

# Method that edits the UI to match the requested screen
func buildHUDUI() -> void:
	var config = SCREEN_CONFIG.get(requestedScreenType)
	
	HUDTitle.text = config["title_text"]
	itemNameHeader.visible = config["item_name_label_visible"]
	nameSelector.visible = config["name_selector_visible"]
	iconScroller.visible = config["icon_scroller_visible"]
	itemIconHeader.visible = config["selected_icon_label_visible"]
	selectedIconImage.visible = config["selected_icon_texture_visible"]
	confirmButton.text = config["confirm_button_text"]
	
	userHUD.visible = true

# Method that presents a certain error message
func showError(message: String) -> void:
	errorLabel.visible = true
	errorLabel.text = message
	await get_tree().create_timer(1.5).timeout
	errorLabel.visible = false

# Methods that act on their respective buttions being pressed. They will open the HUD of their respective screen
# and match the UI with what the user requested
func _on_edit_item_icon_button_pressed(requestedItem: Item) -> void:
	userRequestedItem = requestedItem
	requestedScreenType = HUDTypes.Edit_Item_Icon
	buildHUDUI()
func _on_edit_item_name_button_pressed(requestedItem: Item) -> void:
	userRequestedItem = requestedItem
	requestedScreenType = HUDTypes.Edit_Item_Name
	buildHUDUI()
func _on_add_new_item_button_pressed() -> void:
	requestedScreenType = HUDTypes.Create_Item
	buildHUDUI()

# Method that acts on any of the cancel buttons being pressed. When it happens, It'll close the panel and reset 
# all values that may break the programming
func _on_cancel_button_pressed() -> void:
	userHUD.visible = false
	userRequestedItem = null
	selectedIconIndex = -1
	selectedIconImage.texture = null

# Method that acts on the confirm button in the create item container being pressed. It'll create a new item object
# and add it to the current user's list and update the panel list
func _on_new_item_confirm_button_pressed() -> void:
	# Matches the current screen so that the program can know which specific nodes to look for
	match requestedScreenType:
		HUDTypes.Create_Item:
			var userText: String = getAndVerifyText()
			var selectedIcon: Texture = getAndVerifyImage()
			
			if userText != "" && selectedIcon != null: 
				var newItem: Item = Item.new(userText, selectedIcon)
				get_parent().currentUser.registeredItems.append(newItem)
			else:
				return
		HUDTypes.Edit_Item_Name:
			var userText: String = getAndVerifyText()
			
			if userText != "":
				userRequestedItem.title = userText
			else:
				return
		HUDTypes.Edit_Item_Icon:
			var selectedIcon: Texture = getAndVerifyImage()
			
			if selectedIcon != null:
				userRequestedItem.icon = selectedIcon
			else:
				return
	
	# Finally, closes the UI, resets each necessary value, updates the panels, and starts the 
	# countdown for how much time has passed since the item has been registered
	userHUD.visible = false
	userRequestedItem = null
	selectedIconImage.texture = null
	selectedIconIndex = -1
	nameSelector.text = ""
	buildItemPanel()
	get_parent().currentUser.startOrResumeTimer()
	get_parent().currentUser.alreadyMadeItem = true

# Helper method(s) for above and below methods
func getListOfButtons() -> Array:
	var buttonContainer: HBoxContainer = iconScroller.get_child(0)
	return buttonContainer.get_children()
func getAndVerifyText() -> String:
	if nameSelector.text == "":
		showError("Please enter a name")
		return ""
	return nameSelector.text
func getAndVerifyImage() -> Texture:
		if selectedIconIndex == -1:
			showError("Please select an icon.")
			return null
		return getListOfButtons()[selectedIconIndex].icon

# Method that acts on the icons being selected. It ensures that there's something tracking which 
# icon has been selected while also displaying which icon is selected
func _on_icon_pressed(extra_arg_0: int) -> void:
	var listOfButtons: Array = getListOfButtons()
	
	selectedIconIndex = extra_arg_0
	selectedIconImage.texture = listOfButtons[selectedIconIndex].icon

# Method that acts on the delete item button being pressed. It'll delete the button from the list, from the user 
# database, and check whether the user doesn't have any items
func _on_delete_item_button_pressed(requestedItem: Item) -> void:
	var index: int = 0
	
	for item in get_parent().currentUser.registeredItems:
		if item == requestedItem:
			index = get_parent().currentUser.registeredItems.find(item)
			get_parent().currentUser.registeredItems.remove_at(index)
			buildItemPanel()
			get_parent().currentUser.startOrResumeTimer()
