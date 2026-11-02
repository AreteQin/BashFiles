#!/usr/bin/env bash
#===============================================================================
# Sunshine 一键安装脚本 —— Ubuntu 22.04 + NVIDIA + Tailscale
# Sunshine = 游戏串流服务端（NVENC 硬件编码），客户端用 Moonlight 连接
# 用法: sudo bash install_sunshine.sh
#===============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }
err() { echo -e "${RED}[ERR]${NC} $*"; exit 1; }

[[ $EUID -eq 0 ]] || err "请用 sudo 运行: sudo bash install_sunshine.sh"
REAL_USER="${SUDO_USER:-}"
[[ -n "$REAL_USER" && "$REAL_USER" != "root" ]] || err "请用 sudo 从普通用户运行（不要用 root 直接跑）"

VER="2026.914.233613"
PKG="sunshine_${VER}-1+ubuntu22.04_amd64.deb"
URL="https://github.com/LizardByte/Sunshine/releases/download/v${VER}/sunshine_${VER}-1%2Bubuntu22.04_amd64.deb"
TMP="/tmp/${PKG}"

echo "=========================================="
echo " Sunshine 一键安装脚本 (v${VER})"
echo "=========================================="

# ---- 1. 下载 ----
echo ""
echo ">>> [1/5] 下载 Sunshine deb 包..."
if [[ ! -f "$TMP" ]]; then
    wget -q --show-progress -O "$TMP" "$URL" \
        || curl -fL --progress-bar -o "$TMP" "$URL"
fi
# 校验是 deb 而非错误页面
file "$TMP" | grep -qi 'debian binary' || err "下载文件无效，请删除 $TMP 后重试"
ok "下载完成: $TMP"

# ---- 2. 安装 ----
echo ""
echo ">>> [2/6] 安装 Sunshine 及依赖..."
apt update -y
apt install -y "$TMP"
ok "安装完成: $(sunshine --version 2>/dev/null || echo 'installed')"

# ---- 3. 权限（输入模拟 + udev）----
echo ""
echo ">>> [3/6] 配置输入设备权限..."
if ! id "$REAL_USER" | grep -q 'input'; then
    usermod -aG input "$REAL_USER"
    ok "用户 $REAL_USER 已加入 input 组（重新登录后生效）"
fi
udevadm control --reload-rules 2>/dev/null || true
udevadm trigger 2>/dev/null || true
ok "udev 规则已刷新"

# ---- 4. 写入配置（关键：关闭托盘，否则会 core dump 导致端口不监听）----
echo ""
echo ">>> [4/6] 写入 Sunshine 配置..."
CONF_DIR="/home/${REAL_USER}/.config/sunshine"
mkdir -p "$CONF_DIR"
# system_tray = disabled  → 避免 Qt 托盘初始化崩溃
# capture = x11           → 消费级显卡不支持 NvFBC，强制走 X11 抓屏
# encoder = nvenc         → 使用 NVIDIA 硬件编码
cat > "${CONF_DIR}/sunshine.conf" <<'EOF'
system_tray = disabled
capture = x11
encoder = nvenc
EOF
chown -R "${REAL_USER}:${REAL_USER}" "$CONF_DIR"
ok "已写入 ${CONF_DIR}/sunshine.conf"

# ---- 5. 防火墙 ----
echo ""
echo ">>> [5/6] 放行 Sunshine 端口..."
if command -v ufw &>/dev/null && ufw status | grep -qi 'active'; then
    ufw allow 47984/tcp comment 'Sunshine HTTPS'
    ufw allow 47989/tcp comment 'Sunshine HTTP'
    ufw allow 47990/tcp comment 'Sunshine WebUI'
    ufw allow 48010/tcp comment 'Sunshine RTSP'
    ufw allow 47998:48000/udp comment 'Sunshine stream'
    ufw allow 48002/udp comment 'Sunshine mic'
    ufw allow 48010/udp comment 'Sunshine RTSP'
    ok "ufw 已放行 Sunshine 全部端口"
else
    warn "ufw 未启用，跳过"
fi

# ---- 6. 启动用户服务 ----
echo ""
echo ">>> [6/6] 启动 Sunshine 用户服务..."
USER_UID=$(id -u "$REAL_USER")
# 新版本 deb 包的 unit 名不是 sunshine.service，需自动探测
SUN_UNIT=$(ls /usr/lib/systemd/user/ 2>/dev/null | grep -i 'sunshine.*\.service' | head -1 || true)
SUN_UNIT="${SUN_UNIT:-app-dev.lizardbyte.app.Sunshine.service}"
if sudo -u "$REAL_USER" XDG_RUNTIME_DIR="/run/user/${USER_UID}" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_UID}/bus" \
    systemctl --user enable --now "$SUN_UNIT" 2>/dev/null; then
    ok "sunshine 用户服务已启动并设为开机自启 ($SUN_UNIT)"
else
    warn "自动启动失败，请手动执行: systemctl --user enable --now $SUN_UNIT"
fi

# ---- 验证 ----
echo ""
echo "=========================================="
echo " 验证结果"
echo "=========================================="
sleep 3
if sudo -u "$REAL_USER" XDG_RUNTIME_DIR="/run/user/${USER_UID}" \
    systemctl --user is-active "$SUN_UNIT" 2>/dev/null | grep -q active; then
    ok "sunshine 服务运行中"
else
    warn "服务未确认运行，请检查: systemctl --user status $SUN_UNIT"
fi

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null | head -1 || echo "未检测到")

echo ""
echo -e " ${GREEN}✓ 安装完成！接下来做初始配置：${NC}"
echo ""
echo " 1. 浏览器打开 Web 控制台（本机）:"
echo -e "      ${YELLOW}https://localhost:47990${NC}"
echo "    （自签名证书，浏览器警告选'继续'；首次进入要设置管理员账号密码）"
echo ""
echo " 2. 控制端安装 Moonlight 客户端:"
echo "      Windows/Mac/Android/iOS 均免费，官网 moonlight-stream.org"
echo ""
echo " 3. Moonlight 里添加电脑，地址填:"
echo -e "      Tailscale: ${YELLOW}${TAILSCALE_IP}${NC}"
echo "    会显示 4 位配对 PIN，回到上面的 Web 控制台"
echo "    顶部 'PIN' 页面输入即可完成配对"
echo ""
echo " 4. 配对后点击 Desktop 图标即可串流整个桌面"
echo ""
echo " 提示:"
echo " - 保持本机 GNOME 已登录（Sunshine 抓取当前 X 会话画面）"
echo " - xrdp 可保留作备用，端口不冲突"
echo " - 排障: systemctl --user status $SUN_UNIT"
echo "=========================================="
