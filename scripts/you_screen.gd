extends Control
@export var usernameLabel: Label
@export var passwordLabel: Label
@export var signInScreen: Control

# Method that acts on the visibility changing. It'll display the username and password
func _on_visibility_changed() -> void:
	if self.visible:
		# Removes the text in the password label so that there's no repeating aspects
		passwordLabel.text = ""
		
		usernameLabel.text = get_parent().currentUser.username
		for character in get_parent().currentUser.password:
			passwordLabel.text += "*"

# Method that acts on forgot password button being pressed. 
func _on_forgot_password_button_pressed() -> void:
	self.visible = false
	signInScreen.visible = true
	
	# To ensure that the settings are correct and that the user can do the correct things, 
	# this method can directly edit the current screen mode and altering the visibility of the correct objects
	signInScreen.screenMode = signInScreen.ScreenModes.Forgot_password
	signInScreen.changeUI()

# Method that acts on the user pressing the log out button. It logs the user out, sets the current user to null, 
# and resets the home page
func _on_log_out_button_pressed() -> void:
	self.visible = false
	signInScreen.visible = true
	
	# To ensure that the settings are correct and that the user can do the correct things, 
	# this method can directly edit the current screen mode and altering the visibility of the correct objectss
	signInScreen.screenMode = signInScreen.ScreenModes.Sign_in
	signInScreen.changeUI()
	get_parent().currentUser.userTimer.queue_free()
	get_parent().currentUser = null
	get_parent().currentHomeScreen = signInScreen
