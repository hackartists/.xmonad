dir=$1
ret=$(notify-send 'Ranger' "<span>Save $dir/$2  </span>" --icon=dialog-information -A "Show in folder" -A "Open")
case $ret in
    0)
        echo "mimeo \"$dir\"" >> $HOME/ranger-kdialog.log
        $TERMINAL -e ranger "$dir"
        ;;
    1)
        echo "exo-open \"$dir/$2\"" >> $HOME/ranger-kdialog.log
        exo-open "$dir/$2"
        ;;
esac
