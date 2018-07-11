require_relative '../config/environment'

cli_welcome
cli_ask_name
current_user = find_or_create_user(cli_input)
cli_what_to_do
user_input = cli_input

actions(user_input, current_user)
