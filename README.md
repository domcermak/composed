# Generování obrázků z uživatelských vstupů s využitím neuronových sítí
## Úvod

Toto je aplikace k bakalářské práci na téma Generování obrázků z uživatelských vstupů s využitím neuronových sítí. Aplikace je napsána v jazyce Python a je spouštěna v docker kontejnerech. 

Aplikace je rozdělena do několika částí:
- rabbitmq - RabbitMQ server
- postgres - PostgreSQL databáze
- web - webová aplikace napsaná v jazyce Python s využitím frameworku Streamlit
- worker - aplikace napsaná v jazyce Python, která zpracovává požadavky na generování obrázků

Aplikace je možné spustit na jakémkoliv operačním systému, který podporuje [Minimální hardwarové požadavky](#minimální-hardwarové-požadavky) a [Softwarové požadavky](#softwarové-požadavky).
Aplikace byla testována na operačním systému macOS Ventura 13.3.1 (a) (22E772610a) na zařízení Apple MacBook Pro 16 2023, 16 GB RAM, 12 jader CPU.

## Obsah

- [Minimální hardwarové požadavky](#minimální-hardwarové-požadavky)
- [Softwarové požadavky](#softwarové-požadavky)
- [Stažení aplikace](#stažení-aplikace)
- [Configurace aplikace](#configurace-aplikace)
- [Spuštění aplikace](#spuštění-aplikace)
- [FAQ](#faq)

## Minimální hardwarové požadavky
- 10 GB RAM
- 16 GB swap
- 15 GB místa na disku
- 10 jader CPU
- Obrazovka 1280x800 pixelů

Testováno na zařízení Apple MacBook Pro 16 2023, 16 GB RAM, 12 jader CPU.
- Generování obrázku z náčrtku trvá cca 3 sekundy.
- Generování obrázku z textu trvá jednotky minut.

## Softwarové požadavky
- [docker](https://docs.docker.com/get-docker/)
- [docker-compose](https://docs.docker.com/compose/install/) 
- [git](https://git-scm.com/downloads)

Nastavte docker daemonu dostatečnou RAM paměť, swap, místo na disku a počet jader CPU viz [Minimální hardwarové požadavky](#minimální-hardwarové-požadavky).

## Stažení aplikace
Otevřete terminál a spusťte následující příkaz:

```shell
git clone https://github.com/domcermak/composed.git
```

## Configurace aplikace
Aplikaci je možné konfigurovat pomocí souborů:
- [rabbitmq/rabbitmq.config](./rabbitmq/rabbitmq.config)
- [docker-compose.yml](./docker-compose.yml)

Může nastat problém s nedostatečnými hodnotami timeoutů. V takovém případě je nutné zvýšit hodnoty timeoutů v souboru [rabbitmq/rabbitmq.config](./rabbitmq/rabbitmq.config). Hodnota timeoutu je v sekundách v poli s názvem `heartbeat`.

## Spuštění aplikace

```shell
cd composed
docker-compose up
```

Nyní vyčkejte na spuštění aplikace. Nezavírejte terminál nebo aplikace bude ukončena. Aplikaci můžete ukončit klávesovou zkratkou `CTRL+C`.

Po spuštění aplikace je možné otevřít webovou aplikaci na adrese [http://localhost:8080](http://localhost:8080).

## FAQ