extends ProgressBar

var parent

func _ready():
	
	parent = get_parent()
	
	
	max_value = parent.health_max
	min_value = 0 

func _process(_delta):
	# Update the bar's current value
	self.value = parent.health
	
	# Logic to show/hide the bar
	if parent.health < parent.health_max:
		self.visible = true
		
		
		if parent.health <= 0:
			self.visible = false
	else:
		# Hide if health is full
		self.visible = false
