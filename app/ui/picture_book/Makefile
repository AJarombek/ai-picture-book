.PHONY: install run

install:
	flutter pub upgrade --major-versions
	flutter pub get

check-outdated:
	flutter pub outdated

run:
	flutter run -d chrome --web-port=8080
