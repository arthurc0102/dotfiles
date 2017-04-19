echo -e "========== Checking pacman update ...... ================"
sudo pacman -Syu
echo

echo -e "========== Checking AUR update ...... ==================="
yaourt -Syu --aur --noconfirm
echo
