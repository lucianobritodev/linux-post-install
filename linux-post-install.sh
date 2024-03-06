#!/usr/bin/env bash
#
#-------------------------------------------------------
#
# autor: Luciano Brito
# author: Luciano Brito
#
#-------------------------------------------------------
#
# Creation
#
# Data: 13/02/2024 as 18:00
# Date: 13/02/2024 at 06:00 pm
#
#-------------------------------------------------------
#
# Contacts
#
# e-mail: lucianobrito.dev@gmail.com
# github: github.com/lucianobritodev
#
#-------------------------------------------------------
#
# Version
#
# version: 1.0.0
#
#-------------------------------------------------------
#
# To run the script run one of the following commands:
#
# ./UbuntuPostInstall.sh
#
# or
#
# bash UbuntuPostInstall.sh
#-------------------------------------------------------
#
#
#---------------------- VARIABLES ----------------------

#Colors
readonly TEXT_COLOR_RED='\033[0;31m'
readonly TEXT_COLOR_RED_BOLD='\033[1;31m'
readonly TEXT_COLOR_GREEM='\033[0;32m'
readonly TEXT_COLOR_GREEM_BOLD='\033[1;32m'
readonly TEXT_COLOR_PURPLE='\033[0;34m'
readonly TEXT_COLOR_PURPLE_BOLD='\033[1;34m'
readonly TEXT_COLOR_BLUE='\033[0;36m'
readonly TEXT_COLOR_BLUE_BOLD='\033[1;36m'
readonly COLOR_OFF='\033[0m'

#Messages
readonly SUCCESS_MESSAGE='foi instalado com sucesso!'
readonly ERROR_MESSAGE='não foi instalado!'
readonly ALREADY_MESSAGE='já está instalado!'

#System and Apps
readonly OS="$(cat /etc/os-release | grep '^NAME=' | sed 's/^NAME=//g;s/"//g' | tr [A-Z] [a-z])"
readonly VERSION_CODENAME="$(cat /etc/os-release | grep 'UBUNTU_CODENAME=' | sed 's/UBUNTU_CODENAME=//g')"
readonly UBUNTU="ubuntu"
readonly LINUX_MINT="linuxmint"
readonly DOWNLOADS_TMP='/tmp/downloads'
readonly IDEA_ZIP_PACK=idea.tar.gz
readonly IDEA_VERSION=2023.3.3
readonly IDEA_HOME="/opt/idea"

#Logs
readonly LOG_FILE=/tmp/post-install.log
readonly LOG_INFO="[${TEXT_COLOR_PURPLE_BOLD}INFO${COLOR_OFF}] --- "
readonly LOG_SUCCESS="[${TEXT_COLOR_GREEM_BOLD} OK ${COLOR_OFF}] --- "
readonly LOG_ERROR="[${TEXT_COLOR_RED_BOLD}ERRO${COLOR_OFF}] --- "

#Password
readonly PASSWORD="$(zenity --title="Credenciais de usuário $(lsb_release -i | sed 's/.*://g;s/[\s|\t]//g')" --password)"

#
#----------------------- FUNCTIONS -------------------
#

update() {
	echo -e "${LOG_INFO} Atualizando Sistema..."
	echo "$PASSWORD" | sudo -S apt update
	echo "$PASSWORD" | sudo -S sudo apt upgrade -y

}

install_basic_packages() {

	echo -e "${LOG_INFO} Instalando Pacotes Básicos..."
	echo "$PASSWORD" | sudo -S apt install curl apt-transport-https ca-certificates gpg vlc gparted gdebi filezilla filezilla-common kruler python3-pip -y
	pip3 install -U --no-cache-dir gdown --pre

}

install_git() {

	if ! [[ -x $(which git) ]]; then

		# Install
		echo -e "${LOG_INFO} Instalando Git..."
		echo "$PASSWORD" | sudo -S apt install git -y

		if ! [[ -x $(which git) ]]; then
			echo -e "${LOG_ERROR} Git ${ERROR_MESSAGE}"
		fi
	fi

}

install_docker() {

	git clone https://github.com/lucianobritodev/docker-tools-installer.git
	chmod +x docker-tools-installer/*.sh
	sh docker-tools-installer/docker-tools-installer.sh "$PASSWORD"

}

install_team_viewer() {

	if ! [[ -x $(which teamviewer) ]]; then

		# Add Repository and Keyrings
		echo -e "${LOG_INFO} Instalando Team Viewer..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/teamviewer-keyring.gpg] http://linux.teamviewer.com/deb stable main' >/etc/apt/sources.list.d/teamviewer.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | gpg --dearmor -o /etc/apt/keyrings/teamviewer-keyring.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/teamviewer-keyring.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install teamviewer -y

		if ! [[ -x $(which teamviewer) ]]; then
			echo -e "${LOG_ERROR} Team Viewer ${ERROR_MESSAGE}"
		fi
	fi

}

install_dropbox() {

	if ! [[ -x $(which dropbox) ]]; then

		# Install
		echo -e "${LOG_INFO} Instalando Dropbox..."
		echo "$PASSWORD" | sudo -S apt install dropbox -y

		if ! [[ -x $(which dropbox) ]]; then
			echo -e "${LOG_ERROR} Dropbox ${ERROR_MESSAGE}"
		fi
	fi
}

install_libreoffice() {

	# Add Repository and Keyrings
	echo -e "${LOG_INFO} Instalando LibreOffice..."
	echo "$PASSWORD" | sudo -S add-apt-repository ppa:libreoffice/ppa -y
	echo "$PASSWORD" | sudo -S apt update

	# Install
	echo "$PASSWORD" | sudo -S apt install libreoffice libreoffice-style-breeze libreoffice-style-yaru libreoffice-style-oxygen libreoffice-style-colibre libreoffice-l10n-pt-br -y

}

install_remmina() {

	if ! [[ -x $(which remmina) ]]; then

		# Install
		echo -e "${LOG_INFO} Instalando Remmina..."
		echo "$PASSWORD" | sudo -S apt install remmina remmina-common remmina-plugin-rdp remmina-plugin-secret -y

		if ! [[ -x $(which remmina) ]]; then
			echo -e "${LOG_ERROR} Remmina ${ERROR_MESSAGE}"
		fi
	fi

}

install_pg_admin() {

	if ! [[ -x '/usr/pgadmin4/bin/pgadmin4' ]]; then

		# Add Repository and Keyrings
		echo -e "${LOG_INFO} Instalando PG Admin..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$VERSION_CODENAME pgadmin4 main' >/etc/apt/sources.list.d/pgadmin4.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /etc/apt/keyrings/packages-pgadmin-org.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/packages-pgadmin-org.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install pgadmin4-desktop -y

		if ! [[ -x '/usr/pgadmin4/bin/pgadmin4' ]]; then
			echo -e "${LOG_ERROR} PG Admin ${ERROR_MESSAGE}"
		fi
	fi
}

install_beekeeper_studio() {

	if ! [[ -x '/opt/Beekeeper Studio/beekeeper-studio' ]]; then

		# Add Repository and Keyrings
		echo -e "${LOG_INFO} Instalando Beekeeper..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main' >/etc/apt/sources.list.d/beekeeper-studio-app.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | gpg --dearmor -o /etc/apt/keyrings/beekeeper.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/beekeeper.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install beekeeper-studio -y

		if ! [[ -x '/opt/Beekeeper Studio/beekeeper-studio' ]]; then
			echo -e "${LOG_ERROR} Beekeeper ${ERROR_MESSAGE}"
		fi
	fi
}

configure_launcher_idea() {

	#Criando lançador
	local idea_version_name
	local idea_launcher

	echo -e "${LOG_INFO} Criando lançador do Intellij IDEA..."
	idea_version_name=$(ls $IDEA_HOME/)
	idea_launcher=/usr/share/applications/idea.desktop

	echo "$PASSWORD" | sudo -S bash -c "cat >$idea_launcher" <<EOF
[Desktop Entry]
Name=Intellij IDEA
GenericName=Java IDE
Comment=IDE para desenvolvimento de aplicações Java
Icon=$IDEA_HOME/$idea_version_name/bin/idea.png
Exec=$IDEA_HOME/$idea_version_name/bin/idea.sh %f
Terminal=false
Categories=Development;
Type=Application
StartupNotify=true
StartupWMClass=jetbrains-idea
EOF

	echo "$PASSWORD" | sudo -S ln -s "$IDEA_HOME/$idea_version_name/bin/idea.sh" /usr/bin/idea

	if ! [[ -f "$idea_launcher" ]]; then
		echo -e "${LOG_ERROR} Lançador Intellij IDEA não foi criado!"
	fi

}

install_style_code_schemas() {

	#Configurando Style Code
	local idea_versions

	echo -e "${LOG_INFO} Adicionado configurações de StyleCode no Intellij IDEA..."
	idea_versions=$(ls -1 $HOME/.config/JetBrains | grep -E 'IntelliJIdea.*' | sed 's/[\s|\t]//g;s/ //g')

	while read -r IDEA_INSTALLED_VERSION; do

		mkdir -p "$HOME/.config/JetBrains/$IDEA_INSTALLED_VERSION/codestyles"

		cat <<EOF >"$HOME/.config/JetBrains/$IDEA_INSTALLED_VERSION/codestyles/Default.xml"
<code_scheme name="Default" version="173">
  <JavaCodeStyleSettings>
    <option name="CLASS_COUNT_TO_USE_IMPORT_ON_DEMAND" value="30" />
	<option name="NAMES_COUNT_TO_USE_IMPORT_ON_DEMAND" value="30" />
  </JavaCodeStyleSettings>
  <TypeScriptCodeStyleSettings version="0">
    <option name="SPACE_WITHIN_ARRAY_INITIALIZER_BRACKETS" value="true" />
    <option name="SPACE_BEFORE_FUNCTION_LEFT_PARENTH" value="false" />
    <option name="SPACES_WITHIN_IMPORTS" value="true" />
	<option name="SPACES_WITHIN_INTERPOLATION_EXPRESSIONS" value="true" />
    <option name="SPACES_WITHIN_OBJECT_LITERAL_BRACES" value="true" />
  </TypeScriptCodeStyleSettings>
  <codeStyleSettings language="TypeScript">
    <option name="SPACE_BEFORE_IF_PARENTHESES" value="true" />
    <option name="SPACE_BEFORE_WHILE_PARENTHESES" value="true" />
    <option name="SPACE_BEFORE_FOR_PARENTHESES" value="true" />
    <option name="SPACE_BEFORE_CATCH_PARENTHESES" value="true" />
    <option name="SPACE_BEFORE_SWITCH_PARENTHESES" value="true" />
  </codeStyleSettings>
  <codeStyleSettings language="JAVA">
    <option name="ALIGN_MULTILINE_TERNARY_OPERATION" value="true" />
    <option name="SPACE_BEFORE_ARRAY_INITIALIZER_LBRACE" value="true" />
  </codeStyleSettings>
</code_scheme>
EOF

		if ! [[ -f $HOME/.config/JetBrains/$IDEA_INSTALLED_VERSION/codestyles/Default.xml ]]; then
			echo -e "${LOG_ERROR} Style Code não instalado para a versão $IDEA_INSTALLED_VERSION!"
		fi

		#Configurando Arquivo de Propriedades do IntelliJ
		echo -e "${LOG_INFO} Adicionando configurações de propriedades para a versão $IDEA_INSTALLED_VERSION!"
		cat <<EOF >"$HOME/.config/JetBrains/$IDEA_INSTALLED_VERSION/idea.properties"
# custom IntelliJ IDEA properties

project.tree.structure.show.url=false
EOF

		if ! [[ -f $HOME/.config/JetBrains/$IDEA_INSTALLED_VERSION/idea.properties ]]; then
			echo -e "${LOG_ERROR} Arquivo de propriedades não instalado para a versão $IDEA_INSTALLED_VERSION!"
		fi

	done <<<"$idea_versions"

}

open_and_config_idea() {

	local idea_version_name

	echo -e "${LOG_INFO} Abrindo Intellij IDEA"
	idea_version_name=$(ls "$IDEA_HOME"/)

	if [[ -d "$IDEA_HOME/$idea_version_name" ]]; then

		gnome-terminal --window --title="${LOG_INFO} Configurando IDEA..." -- bash -c "echo -e 'Intellij IDEA está sendo configurado! Aguarde...\n' && bash $IDEA_HOME/$idea_version_name/bin/idea.sh"
		sleep 10
		install_style_code_schemas
	else
		echo -e "${LOG_ERROR} Não foi possível abrir o Intellij IDEA. Diretório do Intellij não encontrado!"
	fi

}

install_idea() {

	if ! [[ -d "$IDEA_HOME" && $(du -shb "$IDEA_HOME" | cut -f1) -gt 0 ]]; then

		echo -e "${LOG_INFO} Instalando Intellij IDEA..."
		mkdir -p $DOWNLOADS_TMP
		curl --progress-bar -jLC- https://download-cdn.jetbrains.com/idea/ideaIU-$IDEA_VERSION.tar.gz -o $DOWNLOADS_TMP/$IDEA_ZIP_PACK

		if ! [[ -s "$DOWNLOADS_TMP/$IDEA_ZIP_PACK" ]]; then
			echo -e "${LOG_ERROR} Não foi possível baixar o Intellij IDEA!"
			return
		fi

		rm -Rf "$IDEA_HOME"
		echo "$PASSWORD" | sudo -S mkdir -p "$IDEA_HOME"
		echo "$PASSWORD" | sudo -S tar -xvzf $DOWNLOADS_TMP/$IDEA_ZIP_PACK -C "$IDEA_HOME"

		if [[ -d "$IDEA_HOME" && $(du -shb "$IDEA_HOME" | cut -f1) -gt 0 ]]; then
			configure_launcher_idea
			open_and_config_idea
		else
			echo -e "${LOG_ERROR} Intellij IDEA ${ERROR_MESSAGE}"
		fi
	fi

}

install_vscode() {

	if ! [[ -x $(which code) ]]; then

		# Add Repository and Keyrings
		echo -e "${LOG_INFO} Instalando VS Code..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main' >/etc/apt/sources.list.d/vscode.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/packages.microsoft.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install code -y

		if ! [[ -x $(which code) ]]; then
			echo -e "${LOG_ERROR} VS Code ${ERROR_MESSAGE}"
		fi
	fi

}

install_sublime_text() {

	if ! [[ -x $(which subl) ]]; then

		# Add Repository and Keyrings
		echo -e "${LOG_INFO} Instalando Sublime Text..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublime-text.gpg] https://download.sublimetext.com/ apt/stable/' >/etc/apt/sources.list.d/sublime-text.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /etc/apt/keyrings/sublime-text.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/sublime-text.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt-get install sublime-text -y

		if ! [[ -x $(which subl) ]]; then
			echo -e "${LOG_ERROR} Sublime Text ${ERROR_MESSAGE}"
		fi
	fi
}

install_postman() {

	if ! [[ -x $(which postman) ]]; then

		# Add Repository
		echo -e "${LOG_INFO} Instalando Postman..."
		echo "$PASSWORD" | sudo -S add-apt-repository ppa:tiagohillebrandt/postman -y
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install postman -y

		if ! [[ -x $(which postman) ]]; then
			echo -e "${LOG_ERROR} Postman ${ERROR_MESSAGE}"
		fi
	fi

}

install_insomnia() {

	if ! [[ -x $(which insomnia) ]]; then

		# Add Repository
		echo -e "${LOG_INFO} Instalando Insomnia..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [trusted=yes arch=$(dpkg --print-architecture)] https://download.konghq.com/insomnia-ubuntu/ default all' >/etc/apt/sources.list.d/insomnia.list"
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install insomnia -y

		if ! [[ -x $(which insomnia) ]]; then
			echo -e "${LOG_ERROR} Insomnia ${ERROR_MESSAGE}"
		fi

	fi

}

install_nvm() {

	if ! [[ -d "$HOME/.nvm" && -s "$HOME/.nvm/nvm.sh" || -d "$HOME/.config/nvm" && -s "$HOME/.config/nvm/nvm.sh" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o NVM $COLOR_OFF"
		curl --progress-bar -jLC- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

		if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
			source "$HOME/.nvm/nvm.sh"
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM NVM $SUCCESS_MESSAGE $COLOR_OFF"

		elif [[ -s "$HOME/.config/nvm/nvm.sh" ]]; then
			source "$HOME/.config/nvm/nvm.sh"
			echo -e "$$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM NVM $SUCCESS_MESSAGE $COLOR_OFF"

		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED NVM $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED NVM $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi
	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM NVM $ALREADY_MESSAGE $COLOR_OFF"
	fi

	[[ -s "$HOME/.nvm/nvm.sh" ]] && source "${HOME}/.nvm/nvm.sh"
	[[ -s "$HOME/.config/nvm/nvm.sh" ]] && source "$HOME/.config/nvm/nvm.sh"
}

install_node() {
	local node_version

	node_version="$(node -v | sed 's/v//g;s/[\s|\t]//g')"
	echo $node_version

	if [[ "$node_version" != "$NODE_SIGCX_VERSION" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o NodeJS $COLOR_OFF"

		nvm install $NODE_SIGCX_VERSION
		node_version="$(nvm version | sed 's/v//g;s/[\s|\t]//g')"

		if [[ "$node_version" = "$NODE_SIGCX_VERSION" ]]; then
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM NodeJS $SUCCESS_MESSAGE $COLOR_OFF"
		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED NodeJS $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED NodeJS $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi
	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM NodeJS $ALREADY_MESSAGE $COLOR_OFF"
	fi

}

install_angular_cli() {

	install_nvm
	install_node

	if [[ ! -x "$HOME/.nvm/versions/node/v12.22.1/lib/node_modules/@angular/cli/bin/ng" || $(ng version | grep 'Angular CLI:' | sed 's/ //g;s/.*://g') != "$ANGULAR_CLI_SIGCX_VERSION" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o Angular/CLI $COLOR_OFF"
		npm install -g @angular/cli@$ANGULAR_CLI_SIGCX_VERSION -y

		if [[ -x "$HOME/.nvm/versions/node/v12.22.1/lib/node_modules/@angular/cli/bin/ng" ]]; then
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM Angular/CLI $SUCCESS_MESSAGE $COLOR_OFF"
			configure_sysctl
		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Angular/CLI $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Angular/CLI $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi
	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM Angular/CLI $ALREADY_MESSAGE $COLOR_OFF"
	fi

}

install_sdkman() {

	if ! [[ -d "$HOME/.sdkman" && -e "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o SDKMAN $COLOR_OFF"

		curl --progress-bar -jLC- "https://get.sdkman.io" | bash
		source "$HOME/.sdkman/bin/sdkman-init.sh"

		if [[ -e "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM SDKMAN $SUCCESS_MESSAGE $COLOR_OFF"
		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED SDKMAN $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED SDKMAN $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi
	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM SDKMAN $ALREADY_MESSAGE $COLOR_OFF"
	fi

	source "$HOME/.sdkman/bin/sdkman-init.sh"

}

install_java() {

	if ! [[ -d "$HOME/.sdkman/candidates/java/$JAVA_SIGCX_VERSION" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o Java $COLOR_OFF"

		install_sdkman
		sdk install java $JAVA_SIGCX_VERSION -y

		if [[ -d "$HOME/.sdkman/candidates/java/$JAVA_SIGCX_VERSION" ]]; then
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM Java $SUCCESS_MESSAGE $COLOR_OFF"
		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Java $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Java $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi

	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM Java $ALREADY_MESSAGE $COLOR_OFF"
	fi

}

install_maven() {

	if ! [[ -d "$HOME/.sdkman/candidates/maven/$MAVEN_SIGCX_VERSION" ]]; then
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_BLUE Instalando o Maven $COLOR_OFF"

		install_sdkman
		sdk install maven $MAVEN_SIGCX_VERSION -y

		if [[ -d "$HOME/.sdkman/candidates/maven/$MAVEN_SIGCX_VERSION" ]]; then
			echo -e "$LOG_TEXT_SUCCESS $TEXT_COLOR_GREEM Maven $SUCCESS_MESSAGE $COLOR_OFF"
		else
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Maven $ERROR_MESSAGE $COLOR_OFF"
			echo -e "$LOG_TEXT_ERROR $TEXT_COLOR_RED Maven $ERROR_MESSAGE $COLOR_OFF" >>$LOG_ERROR
		fi

	else
		echo -e "$LOG_TEXT_INFO $TEXT_COLOR_GREEM Maven $ALREADY_MESSAGE $COLOR_OFF"
	fi

}

install_mailspring() {

	if ! [[ -x $(which mailspring) ]]; then

		# Download
		echo -e "${LOG_INFO} Instalando Mailspring..."
		curl --progress-bar -L "https://updates.getmailspring.com/download?platform=linuxDeb" -o /tmp/mailspring.deb

		# Install
		echo "$PASSWORD" | sudo -S apt install ./mailspring.deb -y
		rm -f /tmp/mailspring.deb

		if ! [[ -x $(which mailspring) ]]; then
			echo -e "${LOG_ERROR} Mailspring ${ERROR_MESSAGE}"
		fi

	fi

}

install_microsoft_fonts() {

	echo -e "${LOG_INFO} Instalando Fontes da Microsoft..."
	echo "$PASSWORD" | sudo -S sh -c "echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true' | debconf-set-selections"
	echo "$PASSWORD" | sudo -S apt install ttf-mscorefonts-installer -y

}

install_edge_browser() {

	if ! [[ -x $(which microsoft-edge-stable) ]]; then

		# Add Repository
		echo -e "${LOG_INFO} Instalando Edge Browser..."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' >/etc/apt/sources.list.d/microsoft-edge.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft-edge.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/microsoft-edge.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install microsoft-edge-stable -y

		if ! [[ -x $(which microsoft-edge-stable) ]]; then
			echo -e "${LOG_ERROR} Edge Browser ${ERROR_MESSAGE}"
		fi

	fi

}

install_chrome_browser() {

	if ! [[ -x $(which google-chrome-stable) ]]; then

		# Add Repository
		echo -e "${LOG_INFO} Instalando Chrome Browser.."
		echo "$PASSWORD" | sudo -S sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' >/etc/apt/sources.list.d/google-chrome.list"
		echo "$PASSWORD" | sudo -S sh -c 'curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg'
		echo "$PASSWORD" | sudo -S chmod go+r /etc/apt/keyrings/google-chrome.gpg
		echo "$PASSWORD" | sudo -S apt update

		# Install
		echo "$PASSWORD" | sudo -S apt install google-chrome-stable -y
		if ! [[ -x $(which google-chrome-stable) ]]; then
			echo -e "${LOG_ERROR} Chrome Browser ${ERROR_MESSAGE}"
		fi

	fi
}

install_firefox_browser() {

	if ! [[ -x $(which firefox) ]]; then
		echo -e "${LOG_INFO} Instalando Firefox Browser..."

		echo "$PASSWORD" | sudo -S snap remove firefox --purge -y
		echo "$PASSWORD" | sudo -S add-apt-repository ppa:mozillateam/ppa -y
		echo "$PASSWORD" | sudo -S sh -c "echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' >/etc/apt/preferences.d/mozilla-firefox"
		echo "$PASSWORD" | sudo -S sh -c "echo 'Unattended-Upgrade::Allowed-Origins:: \"LP-PPA-mozillateam:${VERSION_CODENAME}\";' >/etc/apt/apt.conf.d/51unattended-upgrades-firefox"
		echo "$PASSWORD" | sudo -S apt update
		echo "$PASSWORD" | sudo -S apt install firefox --allow-downgrades -y

		if ! [[ -x $(which firefox) ]]; then
			echo -e "${LOG_ERROR} Firefox Browser ${ERROR_MESSAGE}"
		fi
	fi

}

install_web_browsers() {

	install_edge_browser
	install_chrome_browser
	install_firefox_browser

}

install_deb_apps() {

	# Install utils
	install_basic_packages

	# Install GIT
	install_git

	# Install Docker
	install_docker

	#Install TeamViewer
	install_team_viewer

	#Install Dropbox
	install_dropbox

	# Install LibreOffice
	install_libreoffice

	# Install Remmina
	install_remmina

	# Install PG Admin
	install_pg_admin

	# Install Beekeeper Studio
	install_beekeeper_studio

	# Install Intellij IDEA
	install_idea

	# Install VS Code
	install_vscode

	# Install Sublime Text
	install_sublime_text

	# Install Postman
	install_postman

	# Install Insomnia
	install_insomnia

	# Install MailSpring
	install_mailspring

	# Install Microsoft Fonts
	install_microsoft_fonts

	# Install Browsers
	install_web_browsers

}

configure_gimp() {

	rm -Rf $HOME/.config/GIMP/2.10/fonts
	mkdir -p $HOME/.config/GIMP/2.10/fonts
	gdown -c --no-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1hMRWV-B6tovRY3BipIRrAxE4sFDVIQfg&confirm=t' -O /tmp/fonts.zip
	unzip -oqC /tmp/fonts.zip -d $HOME/.config/GIMP/2.10/

}

install_flatpak() {

	echo "$PASSWORD" | sudo -S add-apt-repository ppa:flatpak/stable -y
	echo "$PASSWORD" | sudo -S apt update
	echo "$PASSWORD" | sudo -S apt install flatpak gnome-software-plugin-flatpak -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

}

install_flatpak_apps() {

	# Install Flatpak support
	echo -e "${LOG_INFO} Instalando Flatpaks..."
	install_flatpak

	# Install Flatpak Apps
	flatpak install --system flathub com.github.unrud.VideoDownloader -y
	flatpak install --system flathub com.discordapp.Discord -y
	flatpak install --system flathub io.github.mimbrero.WhatsAppDesktop -y
	flatpak install --system flathub org.telegram.desktop -y
	flatpak install --system flathub dev.aunetx.deezer -y
	flatpak install --system flathub com.anydesk.Anydesk -y
	flatpak install --system flathub com.obsproject.Studio -y
	flatpak install --system flathub org.gimp.GIMP -y && configure_gimp

}

configure_icon_dash() {

	echo -e "${LOG_INFO} Configurando Ubuntu..."
	if ! [[ -e '/usr/share/icons/Yaru/scalable/actions/view-app-grid-symbolic-backup.svg' ]]; then
		echo "$PASSWORD" | sudo -S mv /usr/share/icons/Yaru/scalable/actions/view-app-grid-symbolic.svg /usr/share/icons/Yaru/scalable/actions/view-app-grid-symbolic-backup.svg
	fi

	echo "$PASSWORD" | sudo -S curl --progress-bar -L https://svgshare.com/getbyhash/sha1-rDiUAQvOh7AtHbAae2VvXEZzf1A= -o /usr/share/icons/Yaru/scalable/actions/view-app-grid-symbolic.svg

}

configure_ubuntu() {

	# Configurando icone de aplicações
	configure_icon_dash

	# Coloca os botões da janela na esquerda
	gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

	# Coloca o botão de aplicativos no topo
	gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

	# Mostra dia da semana no calendário
	gsettings set org.gnome.desktop.interface clock-show-weekday true

	# Install Gnome Software and Gnome Look Plugin
	echo "$PASSWORD" | sudo -S apt install gnome-software gnome-software-common gnome-software-plugin-flatpak chrome-gnome-shell -y

}

configure_os() {

	case "${OS}" in
	"${UBUNTU}")
		configure_ubuntu
		;;
	*)
		echo "Sistema não reconhecido!"
		;;
	esac

}

main() {
	update
	install_deb_apps
	install_flatpak_apps
	configure_os
}

#
#------------------------- EXECUTION --------------
#

if [[ "$PASSWORD" = '' ]]; then
	zenity --error --text="Senha de super usuário é obrigatória."
	exit 1
fi

main
