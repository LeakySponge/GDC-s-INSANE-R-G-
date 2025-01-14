extends Resource
class_name CardAbility

func play(_card: Card) -> bool:
    print("Card ability generic method")
    return true

func get_score_value(_card: Card) -> int:
    return 0

func get_score_value_aimed_at(_card: Card, _card_moused_over: Card) -> int:
    return 0
