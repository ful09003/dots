echo -n "Setting abbrs (ful09003_config).."
abbr ga 'git add'
abbr mtrr 'mtr -nrc 10'
abbr aurs 'cd ~/Documents/development/aurs'

function get_aur
  set AURPATH_BASE $HOME/Documents/development/aurs
  set AURPATH_DESIRED $AURPATH_BASE/$argv

  if test -d $AURPATH_BASE/$argv
     cd $AURPATH_DESIRED
     echo "updating AUR in $(pwd)..."
     git pull
     prevd
  else
    echo "fetching new AUR..."
    git clone https://aur.archlinux.org/$argv.git    
  end
end

function load_1pass_aws
  set VAULT "Dev Stuff"
  set IName "AWS Access"
  export AWS_ACCESS_KEY_ID=(op read "op://$VAULT/$IName/Access Key")
  export AWS_SECRET_ACCESS_KEY=(op read "op://$VAULT/$IName/Secret Key")

  echo "go get that bread :3"
end