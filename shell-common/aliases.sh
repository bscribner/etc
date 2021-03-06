# May be overridden later
alias em='emacs -nw'
alias ec='emacsclient -n'

have_slickedit=`which vs 2>/dev/null`
if [[ '$have_slickedit' != '' ]]; then
        alias vs='vs -new'
fi

platform=`uname`
if [[ "$platform" == 'Darwin' ]]; then
        alias twistd="/System/Library/Frameworks/Python.framework/Versions/Current/Extras/bin/twistd"

        alias du='du -h -d1'
        alias scons='scons -u -j`sysctl -n hw.ncpu`'
        alias make='nice -n 3 make -j`sysctl -n hw.ncpu`'
        alias ps='ps aux'
        slickedit_path=`\ls -d /Applications/SlickEdit* ~/Applications/SlickEdit* 2>/dev/null | sort -rn | head -n 1`
        if [[ $slickedit_path != '' ]]; then
                alias vs='open -a $slickedit_path'
        fi
        if [ -d $HOME/Applications/0xED.app ]; then
                alias he='open -a ~/Applications/0xED.app'
        fi
        if [ -d /Developer/Applications/Qt/Designer.app ]; then
                alias qtd='open -a /Developer/Applications/Qt/Designer.app'
        fi
        alias keychain='open -a /Applications/Utilities/Keychain\ Access.app'
        alias textedit='open -a /Applications/TextEdit.app'
        if [ -d $HOME/Applications/Emacs.app ]; then
                alias emacs="$HOME/Applications/Emacs.app/Contents/MacOS/Emacs"
                alias emacsclient="$HOME/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
                alias em="$HOME/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
                alias ec="$HOME/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
        fi
        alias ls='ls -hFGA'
        alias ll='ls -hFlG'
        alias top='top -o cpu -i 1'
        alias arp-clear='dscacheutil -flushcache'
        alias eject='diskutil eject'
        alias flush-dns='dscacheutil -flushcache'
        alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport'
fi

if [[ "$platform" == 'Linux' ]]; then
        alias du='du -bh --max-depth=1'
        alias scons='scons -u -j`cat /proc/cpuinfo | grep processor | wc -l`'
        alias make='nice -n 3 make -j`cat /proc/cpuinfo | grep processor | wc -l`'
        alias ps='ps -ef'
        alias ls='ls -hFGA --color=auto'
        alias ll='ls -hFlG --color=auto'
        alias top='top -d 1'
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        if ( which xdg-open >& /dev/null ); then
            alias open="xdg-open"
        elif [[ "$DESKTOP_SESSION" == "gnome" ]]; then
            alias open="gnome-open"
        elif [[ "$DESKTOP_SESSION" == "kde" ]]; then
            alias open="kde-open"
        else
            # Default to xdg open... it'll at least remind me to install
            # xdg-utils (or the equivalent).
            alias open="xdg-open"
        fi
fi

# cd-related
alias mkisofs='mkisofs -iso-level 3 -J -L -r'
alias cdrecord='cdrecord dev=0,0,0 -v driveropts=burnfree'

if [ -d $HOME/projects/subversion ]; then
        alias fsfsverify='$HOME/projects/subversion/contrib/server-side/fsfsverify.py'
fi

alias apg='apg -M SNCL -m8 -n1 -t -a0'
alias svnup='svn up `pwd | sed "s|\(.*/projects/[^/]*\).*|\1|"`'
alias grep="grep --color=auto"
alias ngrep="grep -n --color=auto"
alias egrep="egrep --color=auto"
alias negrep="egrep -n --color=auto"

hash colordiff > /dev/null 2>&1 &&
        alias diff="colordiff"

if [ -d $HOME/local/erlang ]; then
        alias erl="$HOME/local/erlang/bin/erl"
        alias erlc="$HOME/local/erlang/bin/erlc"
fi
if [ -d $HOME/.local/erlang ]; then
        alias erl="$HOME/.local/erlang/bin/erl"
        alias erlc="$HOME/.local/erlang/bin/erlc"
fi

# Hunt down the installed clojure files
search_paths=$(echo $JAVA_LOCALLIB | tr ":" "\n")
clojure_jar=
clojure_contrib_jar=
jline_jar=

for search_path in $search_paths
do
    if [ -f $search_path/clojure.jar ]; then
        clojure_jar="$search_path/clojure.jar"
        clojure_contrib_jar="$search_path/clojure-contrib.jar"
        break
    fi
done

for search_path in $search_paths
do
    if [ -f $search_path/jline.jar ]; then
        jline_jar="$search_path/jline.jar"
        break
    fi
done

if [[ "$clojure_jar" != '' ]]; then
        classpath=`append_path "$clojure_contrib_jar" "$clojure_jar"`
        jline_runner=
        if [[ "$jline_jar" != '' ]]; then
                classpath=`append_path "$classpath" "$jline_jar"`
                jline_runner="jline.ConsoleRunner"
        fi

        alias clj="java -XX:+CMSClassUnloadingEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -cp $classpath $jline_runner clojure.main"
fi

if [ -d $HOME/projects/clojure ]; then
        classpath=`append_path "$jline_jar" $HOME/projects/clojure/clojure.jar:\`find_clj_contrib\``
        jline_runner=
        if [[ "$jline_jar" != '' ]]; then
                jline_runner="jline.ConsoleRunner"
        fi

        alias dev-clj="java -XX:+CMSClassUnloadingEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -cp $classpath $jline_runner clojure.main"
fi

unset search_path
unset search_paths
unset clojure_jar
unset clojure_contrib_jar
unset jline_jar
unset jline_runner
unset classpath

alias wget="wget --no-check-certificate"

#alias file='file -L'

alias od='od -A x'
alias traceroute='traceroute -n -w 2'
alias netcat=nc
alias tree='tree -F -v'

# rvm-related
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    # yes, this essentially replaces the system gem... but I like to install
    # libraries for me, and not f-up my entire system.
    alias gem="rvm gem"
    alias compass="rvm exec compass"
    alias rake="rvm rake"
fi
