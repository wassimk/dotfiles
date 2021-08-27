macOS="macOS"
ubuntu="ubuntu"
uname=$(uname -v)

if [[ $uname == *Darwin* ]]
then
  os=$macOS
elif [[ $uname == *Ubuntu* ]]
then
  os=$ubuntu
else
  echo "ERROR: Don't know how to handle this OS"
  exit 1
fi

installPackageManager() {
  case $os in
    $macOS)
      if command -v brew 2>&1 >/dev/null; then
        updateAvailablePackages
      else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      ;;
    $ubuntu)
      updateAvailablePackages
      ;;
  esac
}

updateAvailablePackages() {
  case $os in
    $macOS)
      brew update
      ;;
    $ubuntu)
      sudo apt-get -y update
      ;;
  esac
}

installOrUpdate() {
  case $os in
    $macOS)
      if brew list -l | grep -q "$1"; then
        if brew outdated | grep -q "$1"; then
          brew upgrade $1
        fi
      else
        brew install $1
      fi
      ;;
    $ubuntu)
      sudo apt-get -y install $1
      ;;
  esac
}
