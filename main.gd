extends Node

const player_scene: PackedScene = preload("uid://lac80imicgvx")

@onready var player_spawn_position: Marker2D = $PlayerSpawnPosition
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

func _ready() -> void:
	multiplayer_spawner.spawn_function = func(data):
		var player = player_scene.instantiate() as Player
		player.name = str(data.peer_id)
		player.input_player_authority = data.peer_id
		player.global_position = player_spawn_position.global_position
		return player
	
	peer_ready.rpc_id(1)

@rpc("any_peer", "call_local", "reliable") # this will allow peer_ready to be callable over the networkk
func peer_ready():
	var sender_id = multiplayer.get_remote_sender_id()
	multiplayer_spawner.spawn({ "peer_id": sender_id })
