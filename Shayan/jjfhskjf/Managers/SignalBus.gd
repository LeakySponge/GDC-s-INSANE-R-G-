extends Node

signal pause
signal unpause

signal run_started
signal expedition_started
signal turn_started
signal turn_ended
signal winning_card_played

signal add_ore(int)
signal add_score(int)
signal subtract_ore(int)
signal ore_spent()

signal card_dragged(Card)
signal card_drag_stopped
signal card_selected(Card)
signal card_deselected(Card)
signal card_played(Card)
signal card_clicked(Card)
signal display_score_on_bar(score_amount: int)
signal receive_aiming_moused_over(Card)
signal card_moused_off


signal draw_card(amount: int)
signal discard_card(amount: int)
signal discard_all
signal card_drawn()
signal card_discarded()
signal start_of_turn_draws
signal end_of_turn_discards
signal draw_resources(amount: int)
signal add_card(data_to_add: CardData)
signal add_to_draw_pile(data_to_add: CardData)
signal deck_changed

signal card_aim_started(Card)
signal card_aim_ended(Card)

signal add_energy(int)
signal subtract_energy(int)
signal store_energy(int)
signal energy_added
signal energy_subtracted
signal energy_changed
signal energy_refreshed
signal flag_energy_popup(amount: int)

signal expedition_won
signal entering_shop
signal shop_entered
signal map_entered
signal game_over
signal game_over_animation

signal card_inspected(CardData)
signal card_purchased(CardData)
signal remove_purchased
signal upgrade_purchased
signal ask_to_remove_card()
signal ask_to_upgrade_card()

signal ask_to_show_draw_pile
signal ask_to_show_discard_pile
signal ask_to_show_deck
signal hide_card_pile_display

signal resolution_changed

signal go_clicked_on_map

signal score_requirement_reached

signal tutorial_finished
