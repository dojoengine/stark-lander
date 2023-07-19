<img alt="Dojo logo" src=".github/lander.png">

---
<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/mark-dark.svg">
  <img alt="Dojo logo" align="right" width="120" src=".github/mark-light.svg">
</picture>

<a href="https://twitter.com/dojostarknet">
<img src="https://img.shields.io/twitter/follow/dojostarknet?style=social"/>
</a>
<a href="https://github.com/dojoengine/dojo">
<img src="https://img.shields.io/github/stars/dojoengine/dojo?style=social"/>
</a>

[![discord](https://img.shields.io/badge/join-dojo-green?logo=discord&logoColor=white)](https://discord.gg/PwDa2mKhR4)
[![Telegram Chat][tg-badge]][tg-url]

[tg-badge]: https://img.shields.io/endpoint?color=neon&logo=telegram&label=chat&style=flat-square&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2Fdojoengine
[tg-url]: https://t.me/dojoengine

## Stark Lander

An onchain interpretation of the classic game [Lunar Lander](https://en.wikipedia.org/wiki/Lunar_Lander_(video_game_genre)). Try and land on the ground with a velocity of 0.1m/s. All computation is calculated in [Cairo](https://book.cairo-lang.org/title-page.html) and the game is built using the Dojo engine.


### Systems
- `Start`: Spawns a Lander with some random coordinates
- `Burn`: Adjusts the trajectory of the Lander according to inputs
- `Position`: Returns live position of the Lander
- `Win`: Create Win condition

### Components
- `Lander`: Lander state and computed values
- `Fuel` : TODO: abstract from Lander component

### Game loop
1. Players spawn a lander with `start`
2. Input thrust and angle on each action
3. Compute position according to block and tick forward at constant rate
4. Determine if lander arrives at surface of planet at the correct angle and correct speed

## Pre-requisites

### Clone

```console
git clone https://github.com/dojoengine/stark-lander.git
```

### Install Dojo

```console
curl -L https://install.dojoengine.org | bash

dojoup
```

## Running the game

### Katana
Run Katana in a terminal window using the following command:

```console
katana --allow-zero-max-fee --block-time 1`
```

### Contract
Switch to a new terminal window and run the following commands:

```console
cd contract

sozo build // Build World

sozo migrate // Migrate World
```

### Client
In another terminal window, start the client server by running the following command:

```console
cd client

yarn

yarn dev
```

