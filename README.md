# Shady Modem in a Box
ShadyModemInABox is a simple implementation of @davidmc's design for [ShadySoftModem](https://github.com/Shadytel/shadysoftmodem) and [YATE](https://github.com/yatevoip/yate) in a single Ubuntu container, using [tini](https://github.com/krallin/tini) as the init, which can be configured to accept SIP or link via SIP/IAX2 and provide simple modem services to a VoIP network.

Most commonly used for PPP.

## How to use
Configure YATE as appropriate from the `yate.conf.d` directory, or optionally attach it as a volume for dynamic configuration and run the container.

Running `./build.sh` will build an image tagged with `alexhorner/shadymodeminabox:latest` which you can then run to test with a simple `docker run --rm -it alexhorner/shadymodeminabox`.
