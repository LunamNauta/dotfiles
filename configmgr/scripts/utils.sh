log_message(){
    BOLD="\033[1m"
    BLUE="\033[34m"
    RESET="\033[0m"
    echo -e "${BOLD}${BLUE}$1${RESET}"
}

log_error(){
    BOLD="\033[1m"
    RED="\033[31m"
    RESET="\033[0m"
    echo -e "${BOLD}${RED}$1${RESET}"
}

if ! command -v "unzip" &> /dev/null; then
    log_message "'unzip' needed. Installing..."
    sudo pacman -S unzip
fi

if ! command -v "curl" &> /dev/null; then
    log_message "'curl' needed. Installing..."
    sudo pacman -S curl
fi

if ! command -v "bun" &> /dev/null; then
    log_message "'bun' needed. Installing..."
    curl -fsSL https://bun.com/install | bash
fi