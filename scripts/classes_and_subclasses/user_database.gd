extends Node
class_name UserDatabase

var database: Array[UserData] = []

# Method that matches a given username and password and offers the rest of the information on it
func findUserdata(username: String, password: String) -> UserData:
	for data in self.database:
		if data.username == username && data.password == password:
			return data
	# If it can't find anything, then throw a null into the mix
	return null
