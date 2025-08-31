extends Node

var SceneLoaded = false

var MusicEnabled = false

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
signal hide_tile_viewer(n)
signal start_player_incatation(id)
signal player_start(pos)
signal load_bar(number)
signal remove_load_screen()
signal server_down()
signal retry_connection()
signal stop_enchantation()
signal hide_menu()
signal enable_crt()
signal disable_crt()
signal update_music()
signal update_player_viewer()
signal update_tile_viewer()
