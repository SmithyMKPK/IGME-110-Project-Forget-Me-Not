extends Node
class_name UserData

enum FlowerTypes{
	Blue,
	Red,
	Smexy,
	None
}

var username: String
var password: String
var gardenGelt: int 
var seedInventory: Array[FlowerTypes]
var flowerLayout: Array[TextureRect]
var registeredItems: Array[Item]
var alreadyMadeItem: bool
var timerWentOff: bool
var createdGarden: bool
var userTimer: Timer

# Partially parameterized constructor that gets the user's username and password, and as a default, has no registered
# items
func _init(username: String, password: String) -> void:
	self.username = username
	self.password = password
	self.gardenGelt = 0
	self.registeredItems = []
	self.seedInventory = []
	self.flowerLayout = [] # Will get set up VERY soon
	self.alreadyMadeItem = false
	self.timerWentOff = false
	self.createdGarden = false
	self.userTimer = Timer.new()
	userTimer.timeout.connect(_on_timer_timeout)

# Method that checks to see whether the overall items owned is one. If so, it'll start a brand new timer. If not, it'll check how many
# items the user has and determines whether to pause or unpause it
func startOrResumeTimer() -> void:
	if !alreadyMadeItem:
		self.userTimer.start(30.0)
		print("Started timer")
	else:
		self.userTimer.paused = self.registeredItems.size() <= 0
		print(self.registeredItems.size() <= 0)

# Method that acts on the timer going off.
func _on_timer_timeout():
	self.timerWentOff = true
	self.userTimer.stop()
	print(self.timerWentOff)

# Method that acts on 
