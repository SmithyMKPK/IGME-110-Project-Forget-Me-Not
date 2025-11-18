extends Control

@export var statScreen: VBoxContainer
@export var claimButton: Button
@export var mostCommonAnswer: Label
@export var lostCation: Label
@export var progressBar: ProgressBar

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

# Method that acts on the visiblity being changed. If it's visible, it'll check whether the user has items, and if so,
# provides "statistics" on them. If not, it'll present a "failsafe"
func _on_visibility_changed() -> void:
	if self.visible:
		get_parent().styleBoxPanel.bg_color = Color("a1c0d7")
		if get_parent().currentUser.registeredItems.size() == 0:
			showResults(false)
		else:
			showResults(true)

# Methods that organizes the alignment of the vboxcontainer and shows the only necessary variables
func showResults(passFail: bool):
	if !passFail:
		statScreen.alignment = BoxContainer.ALIGNMENT_CENTER
		for child in statScreen.get_children():
			if child.name == "Failed Image" || child.name == "Failed Title" || child.name == "Failed Subtitle":
				child.visible = true
			else:
				child.visible = false
	else:
		statScreen.alignment = BoxContainer.ALIGNMENT_BEGIN
		
		# Sets each child to be visible
		for child in statScreen.get_children():
			if child.name == "Failed Image" || child.name == "Failed Title" || child.name == "Failed Subtitle":
				child.visible = false
			else:
				child.visible = true
		
		# Gets random items and numbers for an "immersive" feel
		mostCommonAnswer.text = getRandomItem()
		lostCation.text = getRandomLocationName()
		
		if !get_parent().currentUser.timerWentOff:
			# Sets the value of the bar
			progressBar.value = 30 - get_parent().getItemElapsedTime()
			print(progressBar.value)
		else:
			if claimButton.text != "CLAIMED":
				progressBar.value = 30
				claimButton.disabled = false

# Method that returns a random name from your items
func getRandomItem() -> String:
	var currentUserItems: Array[Item] = get_parent().currentUser.registeredItems
	
	return currentUserItems[RNG.randi_range(0, currentUserItems.size() - 1)].title

func getRandomLocationName() -> String:
	var arrayOfRandomLoctaions: Array[String] = ["Gleason F2 Bathroom SW Side", "Gordon Field House Parking Lot", "The Closet That Shall Not Be Talked About", "The Booger Ceiling", 
		"The Adon Smith Worship House", "The 'Man' Cave", "The Batcave", "The Back of the Spencers Backroom", "The Steam Library", "Emmett's House", 
		"1220 East Delmar Street, Springfield, Missouri, 65804"]
	
	return arrayOfRandomLoctaions[RNG.randi_range(0, arrayOfRandomLoctaions.size() - 1)]

# Method that reacts to the claim button being pressed. If it's not disabled, it'll add 1000 GG's to the user's
# account
func _on_claim_button_pressed() -> void:
	get_parent().currentUser.gardenGelt += 1000
	claimButton.disabled = true
	claimButton.text = "CLAIMED"
