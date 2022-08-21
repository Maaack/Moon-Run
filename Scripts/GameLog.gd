extends Node

const GAME_LOG_SECTION = "GameLog"
const APP_OPENED = "AppOpened"
const TOTAL_TIME_PLAYED = "TotalTimePlayed"
const FASTEST_TIME_PLAYED = "FastestTimePlayed"
const TOTAL_COMPLETIONS = "TotalCompletions"
const FIRST_VERSION_PLAYED = "FirstVersionPlayed"
const LAST_VERSION_PLAYED = "LastVersionPlayed"
const UPDATE_COUNTER_RESET = 3.0
const UNKNOWN_VERSION = "unknown"

var app_opened : int = 0
var total_time_played : float = 0.0
var fastest_time_played : float = 999.0
var total_completions : int = 0
var first_version_played : String = UNKNOWN_VERSION setget set_first_version_played
var last_version_played : String = UNKNOWN_VERSION setget set_last_version_played
var update_counter : float = 0.0

func _process(delta):
	total_time_played += delta
	update_counter += delta
	if update_counter > UPDATE_COUNTER_RESET:
		update_counter = 0.0
		Config.set_config(GAME_LOG_SECTION, TOTAL_TIME_PLAYED, total_time_played)

func _sync_with_config() -> void:
	app_opened = Config.get_config(GAME_LOG_SECTION, APP_OPENED, app_opened)
	total_time_played = Config.get_config(GAME_LOG_SECTION, TOTAL_TIME_PLAYED, total_time_played)
	first_version_played = Config.get_config(GAME_LOG_SECTION, FIRST_VERSION_PLAYED, first_version_played)
	last_version_played = Config.get_config(GAME_LOG_SECTION, LAST_VERSION_PLAYED, last_version_played)

func _init():
	_sync_with_config()

func _ready():
	app_opened += 1
	Config.set_config(GAME_LOG_SECTION, APP_OPENED, app_opened)

func set_first_version_played(value : String) -> void:
	if first_version_played != UNKNOWN_VERSION:
		return
	first_version_played = value
	Config.set_config(GAME_LOG_SECTION, FIRST_VERSION_PLAYED, first_version_played)

func set_last_version_played(value : String) -> void:
	last_version_played = value
	Config.set_config(GAME_LOG_SECTION, LAST_VERSION_PLAYED, last_version_played)

func set_version_played(value : String) -> void:
	self.first_version_played = value
	self.last_version_played = value

func set_completion(time_in_sec : float):
	fastest_time_played = Config.get_config(GAME_LOG_SECTION, FASTEST_TIME_PLAYED, fastest_time_played)
	if time_in_sec < fastest_time_played:
		fastest_time_played = time_in_sec
		Config.set_config(GAME_LOG_SECTION, FASTEST_TIME_PLAYED, time_in_sec)
	total_completions = Config.get_config(GAME_LOG_SECTION, TOTAL_COMPLETIONS, total_completions)
	total_completions += 1
	Config.set_config(GAME_LOG_SECTION, TOTAL_COMPLETIONS, total_completions)

