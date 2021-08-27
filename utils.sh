macOS="macOS"
ubuntu="ubuntu"
uname=$(uname -v)

case $uname in
  *Darwin*)
    os=$macOS
    ;;
  *Ubuntu*)
    os=$ubuntu
    ;;
  *)
    echo "ERROR: Don't know how to handle this OS"
    exit 1
esac

installPackageManager() {
  case $os in
    $macOS*)
      if command -v brew 2>&1 >/dev/null; then
        updateAvailablePackages
      else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      ;;
    $ubuntu*)
      updateAvailablePackages
      ;;
  esac
}

updateAvailablePackages() {
  case $os in
    $macOS*)
      brew update
      ;;
    $ubuntu*)
      sudo apt-get -y update
      ;;
  esac
}

installOrUpdate() {
  case $os in
    $macOS*)
      if brew list -l | grep -q "$1"; then
        if brew outdated | grep -q "$1"; then
          brew upgrade "$1"
        fi
      else
        brew install "$1"
      fi
      ;;
    $ubuntu*)
      sudo apt-get -y install "$1"
      ;;
  esac
}
