extends Control

# Enum that expresses the different screen types
enum ScreenModes
{
	Sign_in,
	Sign_up,
	Forgot_password
}

@export var usernameEnterer: LineEdit
@export var passwordEnterer: LineEdit
@export var errorLabel: Label
@export var signInLabel: Label
@export var signUpForgotPasswordContainer: HBoxContainer
@export var logInButton: Button
@export var mapScreen: Control

const SCREEN_CONFIG = {
	ScreenModes.Sign_in: 
		{
		"label_text": "Please Sign In.",
		"username_visible": true,
		"password_visible": true,
		"forgot_visible": true,
		"button_text": "LOGIN"
		},
	ScreenModes.Sign_up: 
		{
		"label_text": "Grow Every Time You Remember.",
		"username_visible": true,
		"password_visible": true,
		"forgot_visible": false,
		"button_text": "SIGN UP"
		},
	ScreenModes.Forgot_password: 
		{
		"label_text": "Let's Regrow Your Password",
		"username_visible": true,
		"password_visible": true,
		"forgot_visible": false,
		"button_text": "SET PASSWORD"
		}
}

var userDatabase: UserDatabase
var screenMode: ScreenModes = ScreenModes.Sign_in

# Creates an instance of the database when the game starts
func _ready() -> void:
	userDatabase = UserDatabase.new()
	changeUI()

# Method that changes the UI as per the screen type. It'll make things visible/invisible, change the text, etc
func changeUI():
	var config = SCREEN_CONFIG.get(screenMode)
	
	signInLabel.text = config["label_text"]
	usernameEnterer.visible = config["username_visible"]
	passwordEnterer.visible = config["password_visible"]
	signUpForgotPasswordContainer.visible = config["forgot_visible"]
	logInButton.text = config["button_text"]

# Method that acts on the log-in button being pressed. What it does will entirely depend on what the current 
# text of the button
func _on_log_in_button_pressed() -> void:
	var enteredUsername: String = getInputText(usernameEnterer)
	var enteredPassword: String = getInputText(passwordEnterer)
	
	clearInputs()
	
	if not validateInput(enteredUsername, enteredPassword):
		return
	
	match logInButton.text:
		"LOGIN":
			handleLogin(enteredUsername, enteredPassword)
		"SIGN UP":
			handleSignup(enteredUsername, enteredPassword)
		"SUBMIT":
			handlePasswordReset(enteredUsername, enteredPassword)

# Helper Methods
func getInputText(input_field: LineEdit) -> String:
	return input_field.text if input_field.text != null else ""

func clearInputs() -> void:
	usernameEnterer.text = ""
	passwordEnterer.text = ""

func validateInput(username: String, password: String) -> bool:
	if username == "" or password == "":
		showError("Username/Password cannot be a null value.", 3.0)
		return false
	return true

func handleLogin(username: String, password: String) -> void:
	var matchedUserData: UserData = userDatabase.findUserdata(username, password)
	
	if matchedUserData != null:
		get_parent().currentUser = matchedUserData
		get_parent().currentHomeScreen = mapScreen
		get_parent().add_child(get_parent().currentUser.userTimer)
		self.visible = false
		mapScreen.visible = true
	else:
		showError("Your username or password is incorrect. Please try again.", 1.0)

func handleSignup(username: String, password: String) -> void:
	for user in userDatabase.database:
		if user.username == username:
			showError("Username already exists", 1.0)
			return
	
	userDatabase.database.append(UserData.new(username, password))
	screenMode = ScreenModes.Sign_in
	changeUI()
	showError("Account made successfully!", 1.0)

func handlePasswordReset(username: String, password: String) -> void:
	var matchedUserData: UserData = userDatabase.findUserDataWithUsername(username)
	
	if password != matchedUserData.password:
		screenMode = ScreenModes.Sign_in
		changeUI()
		showError("Password reset successfully!", 1.0)
	elif password == matchedUserData.password:
		showError("Password already exists.", 1.5)

func showError(message: String, duration: float) -> void:
	errorLabel.visible = true
	errorLabel.text = message
	await get_tree().create_timer(duration).timeout
	errorLabel.visible = false


# Method that acts on the sign up text being pressed. It'll take the user to a place to sign up (nahhhh fr?)
func _on_sign_up_pressed() -> void:
	screenMode = ScreenModes.Sign_up
	changeUI()

# Method that acts on the forgot password button being preesed. It'll take the user to a place to reset their 
# password
func _on_forgot_password_pressed() -> void:
	screenMode = ScreenModes.Forgot_password
	changeUI()

# Method that acts on the back button being pressed. It returns the user back to the sign in screen.
func _on_back_button_pressed() -> void:
	screenMode = ScreenModes.Sign_in
	changeUI()
