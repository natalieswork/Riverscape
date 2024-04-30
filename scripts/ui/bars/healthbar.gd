extends HBoxContainer

@onready var healthbar: TextureProgressBar = $TextureProgressBar
@onready var health_text: Label = $counter/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_healthbar()


func update_healthbar():
	healthbar.value = global.player_health
	health_text.text = str(global.player_health)
	
