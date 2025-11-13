extends CanvasLayer

@export var currentHomeScreen: Control
@export var badScreenMode: bool
@export var validControls: Array[Control]
@export var signInScreen: Control

var currentUser: UserData

# Method that reacts to the home button being pressed. It'll set every other link to being invisible and the 
# homescreen to true
func _on_home_button_pressed() -> void:
	if currentHomeScreen != signInScreen:
		for control in self.get_children():
			if control is Control && control != $"Bottom Bar Control" && control != $"Top Bar Control" && control != $"Main Screen":
				control.visible = false
		currentHomeScreen.visible = true
	else:
		signInScreen.screenMode = signInScreen.ScreenModes.Sign_in
		signInScreen.changeUI()

# Method that activates dark mode for developers (aka me) with bad cords
func _ready():
	if badScreenMode:
		var new_stylebox_normal = $"Main Screen".get_theme_stylebox("panel").duplicate()
		new_stylebox_normal.bg_color = Color(0, 0, 0)
		$"Main Screen".add_theme_stylebox_override("panel", new_stylebox_normal)
		for control in validControls:
			for node in control.get_children():
				applyWhiteToLabels(node)

# Method that returns the amount of time is left on the clock
func getItemElapsedTime() -> float:
	return currentUser.userTimer.time_left

func applyWhiteToLabels(node: Control) -> void:
	for child in node.get_children():
		if child is Label:
			child.add_theme_color_override("font_color", Color(1, 1, 1))
		else:
			applyWhiteToLabels(child)


func _on_red_flower_holder_dropped_flower() -> void:
	pass # Replace with function body.
