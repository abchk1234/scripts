## init.d functions
# you can add other directories (space-separated) in here
readonly INIT_D_DIR='/etc/init.d'
# show a function from initscript/s (and/or glob/s eg 's*')
ifunc(){
   local d f r s=$1 fn="^[[:blank:]]*$1"'\(\)' br='[[:blank:]]*\{'
   shift
   for d in $INIT_D_DIR; do
      for g; do
         for f in "$d/"$g; do
            [ -f "$f" ] || continue
            r=$(sed -En "/$fn($br)?/,/^}/{/^}/q;/$fn$br/n;/$fn/{N;n;};p}" "$f")
            [ "$r" ] && printf '%s\n%s\n' "$f: $s" "$r"
         done
      done
   done
}
# convenience wrappers for the common funcs
idepend(){
   ifunc depend "$@"
}
istart(){
   ifunc start "$@"
}
istop(){
   ifunc stop "$@"
}
ireload(){
   ifunc reload "$@"
}
icheckconfig(){
   ifunc checkconfig "$@"
}

# show the functions defined by an initscript/glob, or all if no args
ishow(){
   local d f
   for d in $INIT_D_DIR; do
      if [ "$*" ]; then
         for f; do
            [ "$f" ] && _ishow "$d/$f"
         done
      else _ishow "$d/*"
      fi
   done
}
_ishow(){
   grep -H '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*()' "$1" | {
      curr=
      while IFS='    :' read -r fname func _; do
         [ "$curr" = "$fname" ] || {
            [ "$curr" ] && echo "${curr##*/}:$f"
            curr=$fname f=
         }
         f+=" ${func%%'()'*}"
      done
      [ "$curr" ] && echo "${curr##*/}:$f"
   }
}