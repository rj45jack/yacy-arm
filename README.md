## YaCy-ARM
The P2P Search Engine for everyone. Please check out YaCy's official site and GitHub pages below.

This is an unofficial port to the ARMv7 CPU. The only changes I made were to the Dockerfile. I replaced OpenJDK8 with AdoptJDK12 for ARM. This compiles well on a Raspberry Pi 3 and runs OK. If you plan on using this in a *production* manner, I suggest using an SBC with more RAM. EG: Rasp Pi 4 or Orange Pi 3.

## Usage

Usage is simple. If you use Docker already just pull down the image and run it.

```
docker pull syzygysystems/yacy-arm
docker run
```

## Links
https://yacy.net/
[https://hub.docker.com/r/syzygysystems/yacy-arm](https://hub.docker.com/r/syzygysystems/yacy-arm)
[https://en.wikipedia.org/wiki/YaCy](https://en.wikipedia.org/wiki/YaCy)
[https://twitter.com/yacy_search?lang=en](https://twitter.com/yacy_search?lang=en)
