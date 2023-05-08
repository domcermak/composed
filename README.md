# Generování obrázků z uživatelských vstupů s využitím neuronových sítí
## Úvod

Toto je aplikace k bakalářské práci na téma Generování obrázků z uživatelských vstupů s využitím neuronových sítí. Aplikace je napsána v jazyce Python a je spouštěna v docker kontejnerech. 

Aplikace je rozdělena do několika částí:
- rabbitmq - RabbitMQ server
- postgres - PostgreSQL databáze
- web - webová aplikace napsaná v jazyce Python s využitím frameworku Streamlit
- worker - aplikace napsaná v jazyce Python, která zpracovává požadavky na generování obrázků

Aplikaci je možné spustit na jakémkoliv operačním systému, který podporuje [Minimální hardwarové požadavky](#minimální-hardwarové-požadavky) a [Softwarové požadavky](#softwarové-požadavky).
Aplikace byla testována na operačním systému macOS Ventura 13.3.1 (a) (22E772610a) na zařízení Apple MacBook Pro 16 2023, 16 GB RAM, 12 jader CPU.

## Obsah

- [Minimální hardwarové požadavky](#minimální-hardwarové-požadavky)
- [Softwarové požadavky](#softwarové-požadavky)
- [Stažení aplikace](#stažení-aplikace)
- [Configurace aplikace](#configurace-aplikace)
- [Spuštění aplikace](#spuštění-aplikace)
- [FAQ](#faq)
    - [Aplikace po startu nejde otevřít](#aplikace-po-startu-nejde-otevřít)
    - [Aplikace po startu negeneruje obrázky](#aplikace-po-startu-negeneruje-obrázky)
    - [Aplikace generuje z náčrtku obrázek s chybou](#aplikace-generuje-z-náčrtku-obrázek-s-chybou)
    - [Aplikace generuje z textu obrázek s chybou](#aplikace-generuje-z-textu-obrázek-s-chybou)

## Minimální hardwarové požadavky
- 12 GB RAM
- 4 GB swap
- 15 GB místa na disku
- 8 jader CPU
- Obrazovka 1280x800 pixelů

Testováno na zařízení Apple MacBook Pro 16 2023, 16 GB RAM, 12 jader CPU.
- Generování obrázku z náčrtku trvá jedotky sekund.
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
V případě změny exportovaného portu v souboru [docker-compose.yml](./docker-compose.yml) je nutné změnit port v adrese.

Pro ověření spuštění dílčích aplikací je možné v **novém** okně terminálu použít příkazy
```shell
docker ps
```
nebo
```shell
docker stats
```

Příkaz `docker ps` by měl vypsat následující výstup:
```shell
CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                                                                                        NAMES
6af1d97034b8   domcermak/web                    "sh -c 'streamlit ru…"   15 minutes ago   Up 15 minutes   0.0.0.0:8080->8080/tcp                                                                       web
d6fe3f77597a   domcermak/worker                 "python3 src/__init_…"   15 minutes ago   Up 15 minutes                                                                                                worker
9fda4cd4b6df   rabbitmq:3.6-management-alpine   "docker-entrypoint.s…"   15 minutes ago   Up 15 minutes   4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, 15671/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp   rabbitmq
f12f4966bf75   postgres:14.2-alpine             "docker-entrypoint.s…"   15 minutes ago   Up 15 minutes   0.0.0.0:5432->5432/tcp                                                                       postgres
```

## FAQ
### Aplikace po startu nejde otevřít

Zkontrolujte, že jsou spuštěné všechny dílčí aplikace viz [Spuštění aplikace](#spuštění-aplikace).

### Aplikace po startu negeneruje obrázky

Aplikace se skládá z několika dílčích aplikací:
- `rabbitmq` - RabbitMQ server
- `postgres` - PostgreSQL databáze
- `web` - webová aplikace napsaná v jazyce Python s využitím frameworku Streamlit
- `worker` - aplikace napsaná v jazyce Python, která zpracovává požadavky na generování obrázků

Dílčí aplikace `worker` se spustí spolu s aplikací `web`, ale může trvat několik minut než se spustí proces generování obrázků, 
protože `worker` musí nejdříve načíst do paměti modely neuronových sítí. 
Tento process může trvat v závislosti na výkonu vašeho zařízení až několik desítek sekund.

Text a náčrtky jsou zpracovávány v pořadí, ve kterém byly odeslány, po načtení modelů neuronových sítí.

### Aplikace generuje z náčrtku obrázek s chybou

Model neuronové sítě pro generování obrázků z náčrtku je natrénován pouze na obrázcích aut, psů, ptáků a květin. 
Pokud je náčrtek například zvířete, které není v trénovacích datech, tak model vygeneruje obrázek s chybou.

### Aplikace generuje z textu obrázek s chybou

Model DALL-E Mini, na kterém je text-to-image proces založen, podporuje pouze anglický jazyk.
Pokud je text v jiném jazyce, model vygeneruje obrázek s chybou.