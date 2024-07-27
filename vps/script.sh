#!/bin/bash

function print_menu() {
  echo
  PS3="请输入需要执行的选项: "
  options=("Debian初始化" "测试脚本" "DD" "设置 SSH Key" "Trojan/VLESS 一键脚本" "Install Docker" "Install Dockge" "Install NezhaAgent" "TCP 窗口调优" "退出")
  select opt in "${options[@]}"
  do
      case $opt in
          "Debian初始化")
              init_debian
              print_menu
              ;;
          "测试脚本")
              test_menu
              print_menu
              ;;
          "DD")
              dd_menu
              print_menu
              ;;
          "设置 SSH Key")
              set_ssh_key
              print_menu
              ;;
          "Trojan/VLESS 一键脚本")
              trojan_vless_config
              print_menu
              ;;
          "Install Docker")
              install_docker
              print_menu
              ;;
          "Install Dockge")
              install_dockge
              print_menu
              ;;
          "Install NezhaAgent")
              install_nezha_agent
              print_menu
              ;;
          "TCP 窗口调优")
              tcp_window_optimization
              print_menu
              ;;
          "退出")
              echo "DUANG~"
              break
              ;;
          *)
              echo "无效的选项 $REPLY"
              print_menu
              ;;
      esac
  done
}

function test_menu() {
  PS3="请选择要运行的测试脚本: "
  test_options=("YABS" "融合怪" "返回")
  select test_opt in "${test_options[@]}"
  do
      case $test_opt in
          "YABS")
              test_yabs
              break
              ;;
          "融合怪")
              test_fusion_monster
              break
              ;;
          "返回")
              break
              ;;
          *)
              echo "无效的选项 $REPLY"
              ;;
      esac
  done
}

function dd_menu() {
  PS3="请选择要运行的 dd 脚本: "
  dd_options=("主脚本" "备份" "ARM" "MoeClub" "返回")
  select dd_opt in "${dd_options[@]}"
  do
      case $dd_opt in
          "主脚本")
              dd_kuusei
              break
              ;;
          "备份")
              dd_teddysun
              break
              ;;
          "ARM")
              dd_arm
              break
              ;;
          "MoeClub")
              dd_moeclub
              break
              ;;
          "返回")
              break
              ;;
          *)
              echo "无效的选项 $REPLY"
              ;;
      esac
  done
}

# 功能: 测试: yabs
function test_yabs() {
  echo "Running yabs script..."
  curl -sL yabs.sh | bash
}

# 功能: 测试: 融合怪
function test_fusion_monster() {
  echo "Running fusion monster script..."
  curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
}

# 功能: dd: kuusei fork
function dd_kuusei() {
  echo "Running dd: kuusei fork script..."
  read -p "Please enter the password to use for dd Debian 12 scripts (default: default_password): " password
  password=${password:-default_password}
  read -p "Please enter the SSH port (default: 34522): " ssh_port
  ssh_port=${ssh_port:-34522}
  bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/kuusei/kuusei-script/main/vps/script/dd.sh') -d 12 -v 64 -port "${ssh_port}" -p "$password"
}

# 功能: dd: teddysun
function dd_teddysun() {
  echo "Running dd: teddysun script..."
  wget -qO InstallNET.sh https://github.com/teddysun/across/raw/master/InstallNET.sh && bash InstallNET.sh
}

# 功能: dd: arm leitbogioro
function dd_arm() {
  echo "Running dd: arm leitbogioro script..."
  wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh && bash InstallNET.sh -debian
}

# 功能: dd: MoeClub
function dd_moeclub() {
  echo "Running dd: MoeClub script..."
  read -p "Please enter the password to use for dd Debian 12 scripts (default: default_password): " password
  password=${password:-default_password}
  read -p "Please enter the SSH port (default: 34522): " ssh_port
  ssh_port=${ssh_port:-34522}
  bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') -u 12 -v 64 -p "$password" -port "${ssh_port}" -a
}

# 功能: Debian 初始化
function init_debian() {
  echo "Initializing Debian..."
  apt update -y && apt upgrade -y
  apt install sudo curl wget vim tmux git rsync htop -y
  
  echo "Installing croc..."
  curl https://getcroc.schollz.com | bash
}

# 功能: set ssh key
function set_ssh_key() {
  echo "Setting SSH key..."
  read -p "Please enter the SSH port (default: 34522): " ssh_port
  ssh_port=${ssh_port:-34522}
  bash <(curl -fsSL 'https://link.kuusei.moe/set-ssh-key') -o -d -p "$ssh_port" -u https://link.kuusei.moe/ssh-key
}

# 功能: trojan/vless config
function trojan_vless_config() {
  echo "Configuring Trojan/VLESS..."
  wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

# 功能: docker 安装
function install_docker() {
  echo "Installing Docker..."
  sudo apt-get update
  sudo apt-get install ca-certificates curl -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "Adding Docker repository..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

# 功能: dockge 安装
function install_dockge() {
  echo "Installing dockge..."

  # 检查并创建目录
  dockge_dir="/home/dockge"
  mkdir -p "$dockge_dir"

  wget -O "$dockge_dir/docker-compose.yml" https://raw.githubusercontent.com/kuusei/kuusei-script/main/vps/dockge/docker-compose.yml

  read -p "Please enter your email (default: user@example.com): " email
  email=${email:-user@example.com}
  read -p "Please enter the dockge host (default: localhost): " dockgeHost
  dockgeHost=${dockgeHost:-localhost}

  env_file="$dockge_dir/.env"
  if [ ! -f "$env_file" ]; then
    touch "$env_file"
  fi
  sed -i "/^EMAIL=/d" "$env_file"
  echo "EMAIL=$email" >> "$env_file"
  sed -i "/^DOCKGE_HOST=/d" "$env_file"
  echo "DOCKGE_HOST=$dockgeHost" >> "$env_file"

  docker compose -f "$dockge_dir/docker-compose.yml" up -d
}

# 功能: nezha-agent 安装
function install_nezha_agent() {
  echo "Installing nezha-agent..."

  nezha_agent_dir="/home/dockge/docker/nezha-agent"
  mkdir -p "$nezha_agent_dir"

  wget -O "$nezha_agent_dir/docker-compose.yml" https://raw.githubusercontent.com/kuusei/kuusei-script/main/vps/nezha-agent/docker-compose.yml

  read -p "Please enter the dashboard domain: " dashboard_domain
  dashboard_domain=${dashboard_domain:-"localhost"}
  read -p "Please enter the secret: " secret

  env_file="$nezha_agent_dir/.env"
  if [ ! -f "$env_file" ]; then
    touch "$env_file"
  fi
  sed -i "/^DASHBOARD_DOMAIN=/d" "$env_file"
  echo "DASHBOARD_DOMAIN=$dashboard_domain" >> "$env_file"
  sed -i "/^SECRET=/d" "$env_file"
  echo "SECRET=$secret" >> "$env_file"

  docker compose -f "$nezha_agent_dir/docker-compose.yml" up -d
}

# 功能: tcp 窗口调优
function tcp_window_optimization() {
  echo "Optimizing TCP window settings..."
  cat <<EOT | sudo tee -a /etc/sysctl.conf
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432
net.ipv4.tcp_rmem = 4096 131072 33554432
net.ipv4.tcp_wmem = 4096 16384 33554432
EOT

  sudo sysctl -p
}

print_menu