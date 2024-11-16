extends ColorRect


## login screen
@onready var email_input_login = $Login/Email/EmailInput
@onready var passw_input_login = $Login/Passw/PasswInput
@onready var show_passw_login = $Login/Passw/PasswInput/PasswToggleBtn
@onready var login_node = $Login

## signup screen
@onready var email_input_signup = $Signup/Email/EmailInput
@onready var passw_input_signup = $Signup/Passw/PasswInput
@onready var confirm_passw_input_signup = $Signup/ConfirmPassw/PasswInput
@onready var show_passw_signup = $Signup/Passw/PasswInput/PasswToggleBtn
@onready var show_passw_confirm = $Signup/ConfirmPassw/PasswInput/PasswToggleBtn
@onready var passw_error_msg = $Signup/ConfirmPassw/PasswInput/ErrorMsg
@onready var signup_node = $Signup


func _ready():
	signup_node.hide()
	passw_error_msg.hide()


func _on_login_btn_pressed():
	if email_input_login.text.is_empty() or passw_input_login.text.is_empty():
		return
	
	var result = await owner.network_connection.authenticate_player_async(false, email_input_login.text, passw_input_login.text)
	
	if result == "Success":
		owner.screen_manager.change_screen(owner.Screens.MENU, self)
	else:
		owner.warning_msg.set_warning_msg(str(result))


func _on_create_acc_btn_pressed():
	if passw_input_signup.text != confirm_passw_input_signup.text or email_input_signup.text.is_empty():
		return
	
	var result = await owner.network_connection.authenticate_player_async(true, email_input_signup.text, passw_input_signup.text)
	
	if result == "Success":
		owner.screen_manager.change_screen(owner.Screens.MENU, self)
	else:
		owner.warning_msg.set_warning_msg(str(result))


func _on_open_create_acc_btn_pressed():
	login_node.hide()
	signup_node.show()


func _on_passw_toggle_btn_pressed(extra_arg_0):
	match (extra_arg_0):
		"Log In Pass Input":
			passw_input_login.secret = !passw_input_login.secret 
			
			if passw_input_login.secret:
				show_passw_login.text = "Show"
			else:
				show_passw_login.text = "Hide"
		"Sign Up Pass Input":
			passw_input_signup.secret = !passw_input_signup.secret 
			
			if passw_input_signup.secret:
				show_passw_signup.text = "Show"
			else:
				show_passw_signup.text = "Hide"
		"Confirm Pass Input": 
			confirm_passw_input_signup.secret = !confirm_passw_input_signup.secret 
			
			if confirm_passw_input_signup.secret:
				show_passw_confirm.text = "Show"
			else:
				show_passw_confirm.text = "Hide"


func _on_passw_input_text_changed(new_text):
	if confirm_passw_input_signup.text.is_empty():
		passw_error_msg.hide()
		return
	
	if passw_input_signup.text != confirm_passw_input_signup.text and !passw_error_msg.visible:
		passw_error_msg.show()
	elif passw_input_signup.text == confirm_passw_input_signup.text and passw_error_msg.visible:
		passw_error_msg.hide()
