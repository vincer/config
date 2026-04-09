alias lt='ll -tr'
alias t='tail'
alias tf='terraform'
alias tfw='terraform workspace show'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'
alias tfwn='terraform workspace new'
alias grep='grep --color=auto --exclude "*.svn*"'

# Avoid printing lines that are super long (e.g. minified JS)
# that will overwhelm terminals with scrolling texts for a long time.
alias ag='ag -W300'

alias td='sudo tcpdump -A -s0 -i any port'
if [ $PAGER ]; then
    alias less=$PAGER
    alias zless=$PAGER
fi

if command -v assh &> /dev/null; then
    alias ssh="$(which assh) wrapper ssh --"
fi

if ! command -v pbcopy &> /dev/null; then
    # not on a mac
    alias pbpaste='osc paste'
    alias pbcopy='osc copy'
fi
alias https='http --default-scheme=https'
