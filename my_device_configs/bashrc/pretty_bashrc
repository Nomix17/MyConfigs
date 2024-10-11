# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

prompt_command(){
    local env_indicator=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        env_indicator="\[\e[38;2;42;122;135m\]($venv_name) \[\e[m\]"
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        env_indicator="\[\e[38;2;42;122;135m\]($CONDA_DEFAULT_ENV) \[\e[m\]"
    fi
    if [ "$PWD" = "$HOME" ]; then
        PS1="${env_indicator}\[\e[38;2;210;180;40m\]~>\[\e[m\] "  # Light yellow-brown for home directory
    else    
        PS1="${env_indicator}\[\e[38;2;210;180;40m\]\w\[\e[m\] "  # Light yellow-brown for other directories
    fi
}
PROMPT_COMMAND=prompt_command

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Qt path correction
export PATH="/usr/lib/qt6/bin:$PATH"

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export PATH="$PATH:/home/pain/.local/bin"

# Conda initialization
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pain/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pain/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pain/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pain/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Aliases
alias ll='ls -l'

# Additional paths
export PATH="$PATH:/home/pain/.spicetify"

