class_name EquipmentMenu
extends CanvasLayer

signal equipment_selected(slot)

const inventory_menu_item_scene := preload("res://src/GUI/InventorMenu/inventory_menu_item.tscn")

@onready var inventory_list: VBoxContainer = $"%InventoryList"
@onready var title_label: Label = $"%TitleLabel"

func _ready() -> void:
	hide()


func build(title_text: String, Equipment_slots: EquipmentComponent) -> void:
#	if !Equipment_slots.slots:
#		button_pressed.call_deferred()
#		MessageLog.send_message("No equipment slots somehow in inventory. This should be impossible", GameColors.IMPOSSIBLE)
#		equipment_selected.emit(null)
#		return
	title_label.text = title_text
	var slots =Equipment_slots.body.duplicate()
	var slot = -1
	while !slots.is_empty():
		slot+=1
		var current_slot = slots.pop_front()
		_register_item(slot,current_slot,current_slot.equiped_item)
	inventory_list.get_child(0).grab_focus()
	show()


func _register_item(index: int, slot: Limb_Component, item:Entity = null) -> void:
	var item_button: Button = inventory_menu_item_scene.instantiate()
	var char: String = String.chr("a".unicode_at(0) + index)
	if item!=null:
		item_button.icon = item.texture
		item_button.add_theme_color_override("icon_normal_color",item.modulate)
		item_button.add_theme_color_override("icon_focus_color",item.modulate)
		var button_text = slot.name_limb+ "( "+item.get_entity_name()+" )"
		item_button.text = "( %s ) %s" % [char,button_text ]
	else:
		item_button.text = "( %s ) %s" % [char, slot.name_limb]
	var shortcut_event := InputEventKey.new()
	shortcut_event.keycode = KEY_A + index
	item_button.shortcut = Shortcut.new()
	item_button.shortcut.events = [shortcut_event]
	item_button.pressed.connect(button_pressed.bind(slot))
	inventory_list.add_child(item_button)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_back"):
		equipment_selected.emit(null)
		queue_free()


func button_pressed(slot:Limb_Component = null) -> void:
	equipment_selected.emit(slot)
	queue_free()
