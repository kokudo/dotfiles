export LANG=ja_JP.UTF-8
export OUTPUT_CHARSET=utf8

#screenを自動で起動したい場合は、↓のコメントを外す
# if [[ $STY = '' ]] then screen -xR; fi

fpath=(~/.zsh-completions/src ${fpath})
autoload -U compinit && compinit
zstyle ':completion:*' list-colors ''

autoload -U colors && colors

# http://mollifier.hatenablog.com/entry/20090814/p1
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '%s:%b '
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# ホスト毎にホスト名の部分の色を作る http://absolute-area.com/post/6664864690/zsh
local HOSTCOLOR=$'%{[38;5;'"$(printf "%d\n" 0x$(hostname|md5sum|cut -c1-2))"'m%}'
local USERCOLOR=$'%{[38;5;'"$(printf "%d\n" 0x$(echo $USERNAME|md5sum|cut -c1-2))"'m%}'

PROMPT="%{${fg[white]}%}>%{[1;36m%}>%{[0;36m%}> %1(v|%{${fg[green]}%}%1v|)%{${fg[yellow]}%}%d%{${reset_color}%}
"
case ${UID} in
0)
  # rootの場合は赤くする
  PROMPT=$PROMPT"%{${fg[red]}%}[%n@%f$HOSTCOLOR%m%{${fg[red]}%}]%{${reset_color}%} "
  ;;
*)
  # root以外の場合は緑
  PROMPT=$PROMPT"%{${fg[green]}%}[$USERCOLOR%n%{${fg[green]}%}@%f$HOSTCOLOR%m%{${fg[green]}%}]%{${reset_color}%} "
  ;;
esac
df=`df -h ~/|tail -n 1`
df=`echo "a$df"|awk '{printf"disk use:%s/%s", $3, $2}'`
RPROMPT='%{[1;31m%}$df%{[0;37m%}'

export EDITOR='/usr/bin/vim'
export PATH=$PATH:/usr/local/play

HISTFILE=~/.zsh_history
HISTSIZE=999999
SAVEHIST=999999
REPORTTIME=2

setopt hist_ignore_all_dups
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_save_no_dups
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt list_packed
setopt complete_aliases
setopt extended_glob
setopt transient_rprompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

alias grep='grep --color=auto -n'
alias ls='ls --color=auto -lhp'
alias tail='tail -n 100'
alias less='less -CR'
alias vi='vim'

alias -s php='php'
alias -s {tar,tar.gz,tgz}='tar xvf'
alias -s zip='unzip'

# for cygwin
cs () { cygstart $1 }
sublime () { cygstart `cygpath -ad /cygdrive/c/Program\ Files/Sublime\ Text\ 3/sublime_text.exe` $1 }

# ssh-agent
echo -n "ssh-agent: "
source ~/.ssh-agent-info
ssh-add -l >&/dev/null
if [ $? = 2 ] ; then
  echo -n "ssh-agent: restart...."
  ssh-agent >~/.ssh-agent-info
  source ~/.ssh-agent-info
fi
if ssh-add -l >&/dev/null ; then
  # echo "ssh-agent: Identity is already stored."
else
  ssh-add
fi
