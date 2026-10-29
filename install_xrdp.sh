#!/usr/bin/env bash
#===============================================================================
# xrdp 一键安装脚本 —— Ubuntu 22.04 + GNOME + Tailscale
# 用法: sudo bash install_xrdp.sh
#===============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }
err() { echo -e "${RED}[ERR]${NC} $*"; exit 1; }

# ---- 检查 root ----
[[ $EUID -eq 0 ]] || err "请用 sudo 运行: sudo bash install_xrdp.sh"

echo "=========================================="
echo " xrdp 一键安装脚本"
echo "=========================================="

# ---- 1. 安装 ----
echo ""
echo ">>> [1/4] 安装 xrdp 及依赖包..."
apt update -y
# 22.04 里没有 gnome-session-xsession，已含在 gnome-session 主包
apt install -y xrdp xorgxrdp dbus-x11 gnome-session
ok "安装完成"

# ---- 2. 加入 ssl-cert 组 ----
echo ""
echo ">>> [2/4] 配置权限和 GNOME 会话..."
if ! id xrdp | grep -q 'ssl-cert'; then
    adduser xrdp ssl-cert
    ok "xrdp 已加入 ssl-cert 组"
fi

# ---- 3. 修改 startwm.sh 防蓝屏 ----
STARTWM="/etc/xrdp/startwm.sh"
if [[ -f "$STARTWM" ]]; then
    cp -a "$STARTWM" "${STARTWM}.bak"
    if ! grep -q 'DBUS_SESSION_BUS_ADDRESS' "$STARTWM"; then
        sed -i '1a unset DBUS_SESSION_BUS_ADDRESS\nunset XDG_RUNTIME_DIR' "$STARTWM"
        ok "startwm.sh 已插入 GNOME 兼容修复"
    else
        ok "startwm.sh 已配置过，跳过"
    fi
fi

# ---- 4. 启动服务 ----
echo ""
echo ">>> [3/4] 启动 xrdp 服务..."
systemctl enable --now xrdp xrdp-sesman
systemctl restart xrdp
ok "xrdp & xrdp-sesman 已启动并设为开机自启"

# ---- 5. 放行防火墙 ----
echo ""
echo ">>> [4/4] 检查防火墙..."
if command -v ufw &>/dev/null && ufw status | grep -qi 'active'; then
    ufw allow 3389/tcp
    ok "ufw 已放行 3389/tcp"
else
    warn "ufw 未启用或不存在，跳过（无防火墙则无需处理）"
fi

# ---- 6. 验证 ----
echo ""
echo "=========================================="
echo " 验证结果"
echo "=========================================="
if ss -tlnp 2>/dev/null | grep -q ':3389 '; then
    ok "RDP 端口 3389 已监听"
else
    err "3389 端口未监听！检查: systemctl status xrdp"
fi

SERVICE_STATE=$(systemctl is-active xrdp 2>/dev/null || true)
[[ "$SERVICE_STATE" == "active" ]] && ok "xrdp 服务状态: active" || err "xrdp 状态异常: $SERVICE_STATE"

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null | head -1 || echo "未检测到")
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}')

echo ""
echo -e " ${GREEN}✓ 安装完成！${NC}"
echo ""
echo " 连接地址："
echo "   Tailscale 网络: ${YELLOW}${TAILSCALE_IP}:3389${NC}"
echo "   局域网:         ${YELLOW}${LAN_IP}:3389${NC}"
echo ""
echo " 登录凭据: 本机用户名 + 密码"
echo " 客户端推荐:"
echo "   Windows: mstsc (自带)"
echo "   Mac:     Microsoft Remote Desktop (App Store)"
echo "   iOS:     Microsoft Remote Desktop (App Store)"
echo ""
echo " 如需排障: sudo journalctl -u xrdp -u xrdp-sesman -f"
echo "=========================================="
