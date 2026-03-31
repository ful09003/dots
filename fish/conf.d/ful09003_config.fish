echo -n "Setting abbrs (ful09003_config).."
abbr ga 'git add'
abbr mtrr 'mtr -nrc 10'

function load_1pass_aws
  set VAULT "Dev Stuff"
  set IName "AWS Access"
  export AWS_ACCESS_KEY_ID=(op read "op://$VAULT/$IName/Access Key")
  export AWS_SECRET_ACCESS_KEY=(op read "op://$VAULT/$IName/Secret Key")

  echo "go get that bread :3"
end

# 'Alternatively, fish also automatically executes a function called fish_user_key_bindings if it exists.'
# Primarily added to address https://github.com/fish-shell/fish-shell/issues/12122, which should be fixed in a future release
function fish_user_key_bindings
  bind alt-backspace backward-kill-word
  bind ctrl-alt-h backward-kill-word
  bind ctrl-backspace backward-kill-token
  bind alt-delete kill-word
  bind ctrl-delete kill-token
end

# ensure_paths sets paths I continually forget about when reimaging a machine.
function ensure_paths
  fish_add_path /usr/local/go/bin
  fish_add_path ~/go/bin

  echo "all done, current PATH: $PATH"
end

# Golang development dependencies
function go_dev_deps
  go install golang.org/x/tools/gopls@latest
end

function local_cc_env
  export ANTHROPIC_AUTH_TOKEN="butts"
  export ANTHROPIC_API_KEY=""
  export ANTHROPIC_BASE_URL="http://smookerton.lan:54403"
end