
# Pre-install file checks
if [ ! -f .emacs ]; then
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@     NO .EMACS CONFIG FILE FOUND       @@"
    echo "@@     @ $PWD                            @@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    #exit
elif [ ! -f .bash_profile ]; then
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@       NO .BASH_PROFILE FILE FOUND     @@"
    echo "@@       @ $PWD                          @@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    exit;
fi

    
# Installation
echo "-> Updating packages & distro ..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get distro-update -y
echo "-> Installing basic packages"
sudo apt-get install -y git nano htop iotop emacs build-essentials git golang terminator curl
echo "-> Installing micro"
curl https://getmic.ro | bash
echo "-> Moving bash config"
cp ./.bash_profile ~/.bash_profile
echo "-> Moving emacs config"
cp ./.emacs ~/.emacs
echo "-> Setting up git"
git config --global user.name "Matthew Carney"
git config --global user.email "matthewcarney64@gmail.com"
echo "-> Cleaning up ..."
sudo apt-get clean
echo "-> Done."
