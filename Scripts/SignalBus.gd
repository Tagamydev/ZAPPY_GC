extends Node

var SceneLoaded = false

signal command(message)
signal new_message(message)
signal new_connection(host, port)
signal start_game()
signal stop_load_animation(message)
signal new_island(x, y)
signal new_player(n, team)
signal add_tiles_to_list(tilesList)
signal select_player(n)
signal select_player_by_id(id)
signal lock_player(player)
signal unlock_player()
signal select_tile(n)
signal hide_player_viewer()
signal hide_tile_viewer()
