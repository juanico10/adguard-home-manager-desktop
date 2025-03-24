# ========================
# Makefile para iperf3
# ========================
# Colores para mensajes informativos
INFO := \033[1;37;44m
RESET := \033[0m
ERROR := \033[1;37;41m

# Variables de sistema
VERSION := $(shell wget -q https://api.github.com/repos/JGeek00/adguard-home-manager/releases -O - | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | grep name | head -n 1 | cut -d '"' -f 4)
URL := $(shell wget -q https://api.github.com/repos/JGeek00/adguard-home-manager/releases -O - | grep zipball_url | head -n 1 | cut -d '"' -f 4)

.PHONY: all clean update build-app upgrade

all: clean update build-app build-deb

clean:
	@echo "$(INFO)🧹 Realizando limpieza...$(RESET)"
	flutter clean

upgrade:
	@echo "$(INFO)🆙 Actualizando dependencias de flutter.$(RESET)"
	flutter upgrade

update:
	@echo "$(INFO)🔍 Instalación de dependencias$(RESET)"
	flutter pub get

pull:
	@echo "$(INFO)⏳ Descargando la última versión disponible...$(RESET)"
	wget -qc "$(URL)"
	@echo "$(INFO)📦 Preparando los archivos y configuraciones necesarias...$(RESET)"
	unzip -q -K "$(VERSION)"

build-app:
	@echo "$(INFO)🔁 Construyendo la aplicación para Linux...$(RESET)"
	@cp .env.sample .env
	flutter build linux --release
	@echo "$(INFO)✅ Compilación completada.$(RESET)"

build-deb: build-app
	@echo "$(INFO)🔃 Generando paquete .deb...$(RESET)"
	rps build linux
	@echo "📦 Paquete .tar.gz listo en $(INFO)build/linux/x64/release/bundle/$(RESET)"
	@echo "📦 Paquete .deb listo en $(INFO)build/linux/x64/release/debian/$(RESET)"

help:
	@echo "$(INFO)Comandos disponibles:$(RESET)"
	@echo "$(INFO) * make build $(RESET) - Construye la aplicación para Linux"
	@echo "$(INFO) * make clean $(RESET) - Limpia basura de flutter"
	@echo "$(INFO) * make upgrade  $(RESET) - Actualiza dependencias de flutter del sistema"
	@echo "$(INFO) * make update  $(RESET) - Actualiza dependencias de flutter de la aplicación"
	@echo "$(INFO) * make pull  $(RESET) - Trae el repositorio de adguard"