extends Control

@onready var icon_rect: TextureRect = %IconRect

@onready var id_label: Label = %IdLabel
@onready var name_label: Label = %NameLabel

@onready var player_rank_label: Label = %PlayerRankLabel
@onready var player_score_label: Label = %PlayerScoreLabel

@onready var new_score_line_edit: LineEdit = %NewScoreLineEdit
@onready var submit_score_button: Button = %SubmitScoreButton

@onready var time_span_option: OptionButton = %TimeSpanOption
@onready var collection_option: OptionButton = %CollectionOption
@onready var show_variant_button: Button = %ShowVariantButton

var play_games_leaderboard: PlayGamesLeaderboard
var play_games_leaderboards_client: PlayGamesLeaderboardsClient

const _EMPTY_SCORE := -1

var _score: PlayGamesLeaderboardScore
var _new_raw_score := _EMPTY_SCORE
var _selected_time_span: PlayGamesLeaderboardVariant.TimeSpan
var _selected_collection: PlayGamesLeaderboardVariant.Collection

func _ready() -> void:
	if play_games_leaderboard:
		GodotPlayGameServices.image_stored.connect(func(file_path: String):
			if file_path == play_games_leaderboard.icon_image_uri:
				GodotPlayGameServices.display_image_in_texture_rect(
					icon_rect,
					file_path
				)
		)
		id_label.text = play_games_leaderboard.leaderboard_id
		name_label.text = play_games_leaderboard.display_name
		_set_up_display_score()
		_set_up_submit_score()
		_set_up_variants()

func _set_up_display_score() -> void:
	if _score == null:
		_load_player_score()
	play_games_leaderboards_client.score_loaded.connect(
		func(leaderboard_id: String, score: PlayGamesLeaderboardScore):
			if leaderboard_id == play_games_leaderboard.leaderboard_id:
				_score = score
				_refresh_score_data()
	)

func _set_up_submit_score() -> void:
	play_games_leaderboards_client.score_submitted.connect(
		func refresh_score(is_submitted: bool, leaderboard_id: String):
			if is_submitted and leaderboard_id == play_games_leaderboard.leaderboard_id:
				_load_player_score()
	)
	new_score_line_edit.text_changed.connect(
		func validate_and_refresh_button(new_text: String):
			if new_text.is_valid_int():
				_new_raw_score = new_text.to_int()
			else:
				_new_raw_score = _EMPTY_SCORE
			
			_refresh_submit_score_button()
	)
	submit_score_button.pressed.connect(func():
		if _new_raw_score:
			play_games_leaderboards_client.submit_score(play_games_leaderboard.leaderboard_id, _new_raw_score)
	)

func _set_up_variants() -> void:
	for timeSpan: String in PlayGamesLeaderboardVariant.TimeSpan.keys():
		time_span_option.add_item(timeSpan)
	for collection: String in PlayGamesLeaderboardVariant.Collection.keys():
		collection_option.add_item(collection)
	
	_selected_time_span = time_span_option.selected as PlayGamesLeaderboardVariant.TimeSpan
	_selected_collection = collection_option.selected as PlayGamesLeaderboardVariant.Collection
	
	time_span_option.item_selected.connect(func(index: int):
		var selected_option := time_span_option.get_item_text(index)
		var new_time_span: PlayGamesLeaderboardVariant.TimeSpan = PlayGamesLeaderboardVariant\
			.TimeSpan[selected_option]
		_selected_time_span = new_time_span
	)
	collection_option.item_selected.connect(func(index: int):
		var selected_option := collection_option.get_item_text(index)
		var new_collection: PlayGamesLeaderboardVariant.Collection = PlayGamesLeaderboardVariant\
			.Collection[selected_option]
		_selected_collection = new_collection
	)
	
	show_variant_button.disabled = false
	show_variant_button.pressed.connect(func():
		play_games_leaderboards_client.show_leaderboard_for_time_span_and_collection(
			play_games_leaderboard.leaderboard_id,
			_selected_time_span,
			_selected_collection
		)
	)

func _load_player_score() -> void:
	play_games_leaderboards_client.load_player_score(
		play_games_leaderboard.leaderboard_id,
		PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME,
		PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC
	)

func _refresh_score_data() -> void:
	if _score:
		player_rank_label.text = _score.display_rank
		player_score_label.text = _score.display_score

func _refresh_submit_score_button() -> void:
	if _new_raw_score == _EMPTY_SCORE:
		submit_score_button.text = "Type a score"
		submit_score_button.disabled = true
	else:
		submit_score_button.text = "Submit %s to score" % _new_raw_score
		submit_score_button.disabled = false
