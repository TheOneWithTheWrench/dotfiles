# If this module depends on an external Tmux plugin, say so in a comment.
# E.g.: Requires https://github.com/aaronpowell/tmux-weather

show_morten() { # This function name must match the module name!
  local index icon color text module

  index=$1 # This variable is used internally by the module loader in order to know the position of  wthis module

  icon="$(  get_tmux_option "@catppuccin_morten_icon"  " " )"
  color="$( get_tmux_option "@catppuccin_morten_color" "$thm_orange" )"
  text="$(  get_tmux_option "@catppuccin_morten_text" "#(~/.tmux/plugins/tmux/custom/go-calendar)")"

  module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
