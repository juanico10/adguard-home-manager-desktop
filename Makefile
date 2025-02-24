.PHONY: all clean update build-app upgrade

all: clean update build-app build-deb

clean:
	@echo "\e[37;44mRealizando limpieza...\033[0m"
	flutter clean

upgrade:
	@echo "\e[37;44mActualizando dependencias...\033[0m"
	flutter upgrade

update:
	@echo "\e[37;44mInstalación de dependencias\033[0m"
	flutter pub get

build-app:
	@echo "\e[37;44mConstruyendo la aplicación para Linux...\033[0m"
	@cp .env.sample .env
	flutter build linux --release
	@echo "\e[37;44mCompilación completada.\033[0m"

build-deb: build-app
	@echo "\e[37;44mGenerando paquete .deb...\033[0m"
	rps build linux
	@echo "\e[37;44mPaquete .tar.gz listo en build/linux/x64/release/bundle/\033[0m"
	@echo "\e[37;44mPaquete .deb listo en build/linux/x64/release/debian/\033[0m"