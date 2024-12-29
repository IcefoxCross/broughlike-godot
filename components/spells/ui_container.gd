class_name UIContainer extends VBoxContainer

func update_spells(spell_list:Array) -> void:
	for i in range(9):
		var spell_label = get_node("SpellLabel%s" % (i+1)) as Label
		if i < spell_list.size():
			spell_label.text = "[%s] %s" % [(i+1), spell_list[i] if spell_list[i] != null else ""]
		else: spell_label.text = ""
