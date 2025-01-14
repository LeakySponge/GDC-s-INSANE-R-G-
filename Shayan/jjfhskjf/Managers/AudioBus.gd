extends Node2D

var volume: = 0.5


var resource_pitch_increase_min: = 0.05
var resource_pitch_increase_max: = 0.07000000000000001
var resource_pitch_scale: = 0.0

signal button_mouse_over
signal button_clicked

signal resource_played

signal action_card_played
signal target_card_played

signal not_enough_energy

signal turn_ended
signal turn_started

signal card_purchased
signal card_upgraded
signal card_removed
signal card_moused_over

signal card_drawn
signal card_discarded
signal reshuffle

signal card_deselected

signal caves_collapse_warning

signal game_over
signal expedition_won
signal last_expedition_won

signal shop_go_clicked

signal start_game

signal play_sound_with_id(String)

func change_volume(value: float):
    volume = clamp(value, 0.0, 1.0)

    for child: AudioStreamPlayer2D in get_children(): child.volume_db = linear_to_db(volume)

func _ready():
    change_volume(volume)

    SignalBus.turn_started.connect(
        func _on_turn_started():
            resource_pitch_scale = randf_range(0.9, 1.1)
    )

    play_sound_with_id.connect(
        func _on_play_sound_with_id(id: String):
            if not id: return
            get_node(id).play()
    )

    button_mouse_over.connect(
        func _on_button_mouse_over():
            $MenuButtonMousedOver.play()
    )

    button_clicked.connect(
        func _on_button_clicked():
            $MenuButtonClicked.play()
    )

    card_moused_over.connect(
        func _on_card_moused_over():
            $CardMousedOver.play()
    )

    resource_played.connect(
        func _on_resource_played():
            var randomizer: int = randi_range(1, 3)
            var sound: AudioStreamPlayer2D
            match randomizer:
                1: sound = $ResourcePlayed1
                2: sound = $ResourcePlayed2
                3: sound = $ResourcePlayed3

            sound.pitch_scale = resource_pitch_scale
            resource_pitch_scale = clamp(resource_pitch_scale + randf_range(resource_pitch_increase_min, resource_pitch_increase_max), 0.0, 1.5)
            sound.play()
    )

    card_drawn.connect(
        func _on_card_drawn():
            $CardDrawn.play()
    )

    card_discarded.connect(
        func _on_card_discarded():
            $CardDiscarded.play()
    )

    reshuffle.connect(
        func _on_reshuffle():
            var randomizer: int = randi_range(1, 2)
            var sound: AudioStreamPlayer2D
            match randomizer:
                1: sound = $"Reshuffle 1"
                2: sound = $"Reshuffle 2"
            sound.pitch_scale = randf_range(0.95, 1.05)
            sound.play()
    )

    turn_started.connect(
        func _on_turn_started():
            $TurnStarted.play()
    )

    turn_ended.connect(
        func _on_turn_ended():
            $TurnEnded.play()
    )

    caves_collapse_warning.connect(
        func _on_caves_collapse_warning():
            $CavesCollapseWarning.play()
    )

    game_over.connect(
        func _on_game_over():
            $GameOver.play()
    )

    expedition_won.connect(
        func _on_expedition_won():
            $ExpeditionWon.play()
    )

    last_expedition_won.connect(
        func _on_last_expedition_won():
            $LastExpeditionWon.play()
    )

    card_purchased.connect(
        func _on_card_purchased():
            $CardPurchased.play()
    )

    card_removed.connect(
        func _on_card_removed():
            $CardRemoved.play()
    )

    card_upgraded.connect(
        func _on_card_upgraded():
            $CardUpgraded.play()
    )

    card_deselected.connect(
        func _on_card_deselected():
            $CardDeselected.play()
    )

    not_enough_energy.connect(
        func _on_not_enough_energy():
            $NotEnoughEnergy.play()
    )
