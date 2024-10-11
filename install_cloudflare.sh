echo "============================================="
echo "Installing Cloudflare, choose Ubuntu version"
echo "(1) Lower than Ubuntu 24.04"
echo "(2) Ubuntu 24.04"
read system

case ${system} in
    "1")
        # For 18, 20 and 22
        curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

        echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

        sudo apt-get update && sudo apt-get install cloudflare-warp -y
        ;;
    "2")
        # For 24
        curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

        echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ jammy main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

        sudo apt-get update && sudo apt-get install cloudflare-warp -y
        ;;
esac

echo "============================================="
echo "CloudFlare installed!"