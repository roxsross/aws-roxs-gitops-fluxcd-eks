#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
K9S_VERSION=v0.27.4
KUBECTL_VERSION=v1.25.4
FLUX_VERSION=2.0.1

info() {
  echo -e "\033[0;32m$1\033[0m"
}

warn() {
  echo -e "\033[0;93m$1\033[0m"
}

error() {
  echo -e "\033[0;91m$1\033[0m" >&2
}

usage() {
  local SELF=$(basename "$0")
  cat <<EOF

USAGE:
  k8stools by 🅡🅞🅧🅢
  $SELF -h,--help              : Show this message
  $SELF install                : install all k8s tools
  $SELF install kubectl        : Install kubectl
  $SELF install k9s            : Install k9s
  $SELF install flux           : Install flux
EOF
}

version_compare() {
  local current_version="$1"
  local required_version="$2"
  if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" == "$required_version" ]]; then
    return 0  
  else
    return 1  
  fi
}

install::kubectl() {
  info "[Install] Checking kubectl..."
  if ! command -v kubectl &>/dev/null; then
    info "[Download] kubectl ${KUBECTL_VERSION}"
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" || exit $?
    echo "$(curl -Ls "https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256") kubectl" | sha256sum -c || {
      error "Failed to verify kubectl download."
      cleanup 1
    }
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/
    info "kubectl installed."
  else
    local current_version
    current_version="$(kubectl version --client --short | awk '{print $3}')"
    if version_compare "$current_version" "$KUBECTL_VERSION"; then
      warn "kubectl version is already greater or equal to $KUBECTL_VERSION."
    else
      info "[Download] kubectl ${KUBECTL_VERSION}"
      curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" || exit $?
      echo "$(curl -Ls "https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256") kubectl" | sha256sum -c || {
        error "Failed to verify kubectl download."
        cleanup 1
      }
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/
      info "kubectl updated to version $KUBECTL_VERSION."
    fi
  fi
}

install::k9s() {
  info "[Install] Checking k9s..."
  if ! command -v k9s &>/dev/null; then
    info "[Install] k9s is not installed yet"
    curl -sS https://webinstall.dev/k9s | bash
    mv ~/.local/bin/k9s /usr/local/bin
    info "k9s installed."
  else
    warn "k9s is already installed."
  fi
}

install::flux() {
  info "[Install] Checking flux..."
  if ! command -v flux &>/dev/null; then
    info "[Download] flux ${FLUX_VERSION}"
    curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=$FLUX_VERSION bash || exit $?
    info "flux installed."
  else
    local current_version
    current_version="$(flux --version | awk '{print $3}')"
    if version_compare "$current_version" "$FLUX_VERSION"; then
      warn "flux version is already greater or equal to $FLUX_VERSION."
    else
      info "[Download] flux ${FLUX_VERSION}"
      curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=$FLUX_VERSION bash || exit $?
      info "flux updated to version $FLUX_VERSION."
    fi
  fi
}

install::all() {
  info "K8s Tools by 🅡🅞🅧🅢"
  install::kubectl
  install::k9s
  install::flux
}

env::setpath() {
  echo "export PATH=$HOME/bin:\$PATH" >>~/.bashrc
  source ~/.bashrc
}

main() {
  local cmd=''
  local target=''

  while (( $# )); do
    case "${1:-}" in
      env)
        cmd=${1}
        shift
        break
        ;;
      install)
        if [[ -z "$2" ]]; then
          install::all
          env::setpath
          exit
        elif [[ "$2" == "kubectl" ]]; then
          install::kubectl
          env::setpath
          exit
        elif [[ "$2" == "k9s" ]]; then
          install::k9s
          env::setpath
          exit
        elif [[ "$2" == "flux" ]]; then
          install::flux
          env::setpath
          exit          
        fi
        ;;
      -h|--help)
        usage
        exit
        ;;
      *)
        error "Invalid command: $1"
        usage
        exit 1
        ;;
    esac
    shift || {
      usage
      exit 1
    }
  done

  if [[ -z "$cmd" ]]; then
    error "No command specified."
    usage
    exit 1
  fi
}

main "$@"
