export AWS_PROFILE=pd

if [[ -f ~/driving/scripts/shell/zooxrc.sh ]]; then
    source ~/driving/scripts/shell/zooxrc.sh
fi

if [ -z "$MAC_NAME" ] ; then
    # Things only to run on Zoox linux desktop.

    # Force Homebrew to use a brew-installed curl instead of system curl which is particularly
    # old on 14.04.
    HOMEBREW_FORCE_BREWED_CURL=1
    # So our k8s setup doesn't try to launch a browser
    export NO_LOCAL_WEBSERVER=1
    # So homebrew-built curl can find zoox ca cert
    export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

function pr-to-sha() {
    pr=$1

    shas=$(git -C ~/driving --no-pager log --grep="(#$pr)$" --pretty=oneline origin/master)

    if [[ -z $shas ]]; then
        echo "PR #$pr not found."
    else
        echo $shas
    fi
}
