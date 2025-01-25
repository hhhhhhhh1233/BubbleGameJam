extends Node3D

# Current wave
@export var wave_count : int
# Number of enemies total to spawn this wave
var total_wave_enemy_count : int
# Number of enemies left to spawn in the current wave
@export var enemies_left_to_spawn : int
# Concurrent enemy spawns
var concurrent_spawns : int
# Time between waves
var wave_cooldown : float
# Time between new enemy spawns
var spawn_delay : float
# Bool for if wave is undergoing
@export var wave_ongoing : bool = false

@export var enemy_scene : PackedScene

@export var enemy_spawnpoints: Array[Marker3D]

var disabled_spawnpoints : Array[Marker3D]
var enabled_spawnpoints : Array[Marker3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add spawnpoints to spawnpoint array
	for child in $spawnpoints.get_children():
		if child is Marker3D:
			enemy_spawnpoints.push_back(child)
			print("Spawnpoint size", enemy_spawnpoints.size())
	wave_count = 0
	total_wave_enemy_count = 5
	enemies_left_to_spawn = total_wave_enemy_count
	spawn_delay = 5
	concurrent_spawns = 1
	wave_cooldown = 3.0
	disabled_spawnpoints = enemy_spawnpoints.duplicate()
	enabled_spawnpoints.push_back(disabled_spawnpoints.pop_at(randi_range(0, disabled_spawnpoints.size() - 1)))
	
	await get_tree().create_timer(2.0).timeout
	_begin_wave()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#	print("Enemies left: ", ($enemies.get_child_count() + enemies_left_to_spawn))	
	#end round if all enemies are dead and there ar no more left to spawn
	if $enemies.get_child_count() == 0 && wave_ongoing && enemies_left_to_spawn == 0:
		print("END!")
		wave_ongoing = true
		_end_wave()


func _spawn_enemy():
	if enemies_left_to_spawn == 0:
		return
	var spawn_list : Array[int] 
	spawn_list.resize(enabled_spawnpoints.size())
	spawn_list.fill(0)
	
	for i in range(concurrent_spawns):
			var spawn_point_index : int
			while true:
				randi_range(0, enabled_spawnpoints.size() - 1)
				if spawn_list[spawn_point_index] < 8:
					spawn_list[spawn_point_index] += 1
					break
					
	for i in range(spawn_list.size()):
		for spawn_count in range(1, spawn_list[i] + 1):
			var enemy = enemy_scene.instantiate()
			var spawn_pos = get_node(enabled_spawnpoints[i].get_child(0).get_child(0).get_path())
			spawn_pos.progress_ratio = (float(spawn_count)/float(spawn_list[i]))
			print(spawn_pos.position, " : ", spawn_pos.progress_ratio)
			$enemies.add_child(enemy)
			enemy.position = spawn_pos.position + Vector3(0, 2, 0)
			enemies_left_to_spawn -= 1
			
			
	#print("Points: ", enemy_spawnpoints.size(), "\n disabled: ", disabled_spawnpoints.size())
	await get_tree().create_timer(spawn_delay).timeout
	_spawn_enemy()
	#spawn_timer.start(spawn_delay)


func _begin_wave():
	wave_count += 1
	if wave_count > 1:
		total_wave_enemy_count *= 1.2
		enemies_left_to_spawn = total_wave_enemy_count
		if wave_count % 2 == 0:
			concurrent_spawns += 1
		if wave_count % 3 == 0:
			enabled_spawnpoints.push_back(disabled_spawnpoints.pop_at(randi_range(0, disabled_spawnpoints.size() - 1)))
			spawn_delay *= 0.9
	_spawn_enemy()
	wave_ongoing = true

func _end_wave():
	await get_tree().create_timer(wave_cooldown).timeout
	_begin_wave()


func _on_wave_reset_timer_timeout() -> void:
	pass # Replace with function body.
