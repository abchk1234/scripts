reminder() {                                                                
  echo notify-send "$2" | at now + $1 min &>/dev/null
  echo "Reminder: $2 set for $1 minutes from now"
}
