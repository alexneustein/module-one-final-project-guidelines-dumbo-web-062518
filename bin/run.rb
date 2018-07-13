require_relative '../config/environment'

# binding.pry

cli_welcome
cli_ask_name
current_user = find_or_create_user(cli_input)
cli_what_to_do



actions(current_user)
