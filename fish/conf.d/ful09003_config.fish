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
