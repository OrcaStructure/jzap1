extends Node
var player
var playback
var music_player
var sound_muted = false
var music_muted = false
var song_number = 0
var music_bus
var active_sounds = []
var sound_bus
var music = [preload("res://music/Night Vision - Bird Creek.mp3"),preload("res://music/Spring Thaw - Asher Fulero.mp3"),preload("res://music/New Morning - TrackTribe.mp3")]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	music_player.finished.connect(on_music_finished)
	music_player.stream = music[song_number]

	var polyphonic = AudioStreamPolyphonic.new()
	polyphonic.polyphony = 32
	player.stream = polyphonic
	player.bus = "SFX"
	player.play()
	playback = player.get_stream_playback()
	music_bus = AudioServer.get_bus_index("Music")
	sound_bus = AudioServer.get_bus_index("SFX")
	print(music_bus)
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(0.05))

func on_music_finished():
	song_number += 1
	if song_number >= len(music):
		song_number = 0
	music_player.stream = music[song_number]
	music_player.play()
	
func play(sound,volume=1.0):
	var id = playback.play_stream(sound,0.0,linear_to_db(volume),1.0)
	active_sounds.append(id)
	return id

func clear_active():
	for i in range(len(active_sounds)):
		var id = active_sounds.pop_front()
		if playback.is_stream_playing(id):
			playback.stop_stream(id)


func _input(event):

	if event.is_action_pressed("Music"):
		if music_muted:
			AudioServer.set_bus_mute(music_bus,false)
		else:
			AudioServer.set_bus_mute(music_bus,true)
		music_muted = !music_muted
	elif event.is_action_pressed("Sound"):
		if sound_muted:
			AudioServer.set_bus_mute(sound_bus,false)
		else:
			AudioServer.set_bus_mute(sound_bus,true)
		sound_muted = !sound_muted
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
