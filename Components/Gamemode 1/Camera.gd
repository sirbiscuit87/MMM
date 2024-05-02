extends Camera2D

@export var player: RigidBody2D
@export var wave: Node2D # temp
var player_height: int
var player_distance: int

var current_best_height: int
var current_best_distance: int 

var height_high_score_updated: bool # Used to emit the signal to show that a new high score has been achieved mid-game
var dist_high_score_updated: bool

func _pregame_begin():
	
	height_high_score_updated = false
	dist_high_score_updated = false
	
	# Reload high score every pregame in case it was updated last run
	var cfg = ConfigFile.new()
	cfg.load("user://PlayerData.cfg")
	current_best_distance = cfg.get_value("GM1Scores", "best_distance", 0)
	current_best_height = cfg.get_value("GM1Scores", "best_height", 0)
	
	set_process(false)
	zoom = Vector2(1,1)
	offset = Vector2(200, 0) # Offset above at start
	position = Vector2(250,-428)
	
func _game_begin():
	fixing_offset = true
	set_process(true)




var fixing_offset = false
func _process(delta):
	#position = player.position
	if player != null:
		position.x = player.position.x
		
		# For high scores / camera movement
		player_height = -1 * int(player.position.y - wave.position.y)
		player_distance = player.position.x - 250 # Starting x pos
		
		# Simple as.
		if player_height > current_best_height:
			current_best_height = player_height
			
			# For feedback to user
			if !height_high_score_updated:
				height_high_score_updated = true
				# Hardref, too lazy to signal
				$"../UI Layer/Control/GameControls/NewHeight".flash()
				
		if player_distance > current_best_distance:
			current_best_distance = player_distance
			
			# For feedback to user
			if !dist_high_score_updated:
				dist_high_score_updated = true
				# Hardref, too lazy to signal
				$"../UI Layer/Control/GameControls/NewDist".flash()
			
		$Height.text = str(player_height - 1400)
		
		# Shifting inital offset to game offset
		if fixing_offset:
			
			position.y = player.position.y 
			
			if position.y > 450:
				fixing_offset = false
		
		else:
			var height_to_zoom = 1 - max(player_height, 0) * 0.0005
			zoom.x = max(0.4, height_to_zoom)
			zoom.y = max(0.4, height_to_zoom)
			
			if zoom.x <= 0.42: # Max zoom, drag cam at height 1164, y value -634
				position.y = lerp(wave.position.y, -634.0, 0.5)
				if player_height > 1400:
					$Arrow.show()
					$Height.show()
					var scalefactor = max(2, 5.0 - ((player_height - 1400) / 50) * 0.2)
					$Arrow.scale = Vector2(scalefactor, scalefactor)
				else:
					$Arrow.hide()
					$Height.hide()
					$Arrow.scale = Vector2(5, 5)
			else:
				position.y = lerp(wave.position.y, player.position.y, 0.5)
				
			
			
	

func _on_gamemode_1_game_lost():
	# Update high scores.
	var cfg = ConfigFile.new()
	cfg.load("user://PlayerData.cfg")
	cfg.set_value("GM1Scores", "best_distance", current_best_distance)
	cfg.set_value("GM1Scores", "best_height", current_best_height)
	
	# DEBUG ------ Resets high scores on loss, comment out
	#cfg.set_value("GM1Scores", "best_distance", 0)
	#cfg.set_value("GM1Scores", "best_height", 0)
	
	cfg.save("user://PlayerData.cfg")
