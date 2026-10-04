# Multy Hub Loader

## How to use

Paste this in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/multyplyy/multyHubLoader/main/loader.luau"))()
```

If you're in a supported game it loads. If not, it tells you.

You can also drop the loader in your executor's `autoexec` folder so it runs every time you
join a game. Supported game, script loads by itself. Unsupported game, nothing happens.
Handy if you play more than one of these.

## Games

**All scripts are offline for now.** Most obfuscators have been cracked and Luraph is no
longer reliable, so nothing ships until that changes. Running the loader in a supported game
shows an offline notice. Check the Discord for updates.

| Game | Status |
|------|--------|
| Blackhawk Rescue Mission 5 | Offline for now, paid |
| bug fixes | Offline for now, private, key from staff only |
| Cold War | Offline for now, private, key from staff only |
| Naramo Nuclear Plant | Offline for now, free, no key |
| TTK Testing | Offline for now, free, no key |
| Apocalypse Rising 2 | Offline, not maintained |
| Havoc | Discontinued |
| SCP: Site Roleplay | Discontinued |
| Refinery Caves 2 | Discontinued |
| Energy Assault | Discontinued |
| Valley Prison | Discontinued |

Apocalypse Rising 2 isn't updated anymore, so it has broken features and a ban risk. The
discontinued scripts are gone for good and the loader no longer recognises their games.

## Keys

BRM5 is paid. Paste your key into the key window the first time the loader runs, it gets
saved to `multyhub_key.txt` and reused after that.

Plans are 4.99 EUR / week, 9.99 EUR / month, or 19.99 EUR one-time for lifetime. All three
unlock the same thing, only the length differs. Buy at
[scpscript.info/payment](https://www.scpscript.info/payment/) or with `/buy` in Discord.

Naramo and TTK are free and need no key, just run the loader.

bug fixes and Cold War are private. They are not for sale and a MultyHub key does not unlock
them; keys are handed out by staff, and HWID resets for them are done by staff in a Discord
ticket. One private key unlocks both. It is saved separately, to `multyhub_privates_key.txt`,
so it never overwrites your MultyHub key.

## "Is this a virus?"

No.

The loader is right here in this repo, `loader.luau`. It checks what Roblox game you're in and
loads the matching script. That's all it does.

The game scripts themselves are obfuscated, which just means the code is scrambled so it can't
be copied or read easily. Every script project out there does that. Obfuscation is not malware,
it's code protection.

Nothing here touches your files, installs anything, or does anything outside of Roblox.

## Links

- Website: [scpscript.info](https://scpscript.info)
- Discord: [discord.gg/UPRtgK6tEJ](https://discord.gg/UPRtgK6tEJ)
