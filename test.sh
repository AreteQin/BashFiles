echo "============================================="
echo "Configure cloudflare? (y/n)"
read cloudflare

cd ~/Downloads/BashFiles/
if [ "$cloudflare" == "y" ]; then
    bash ./install_cloudflare.sh
fi
