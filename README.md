# Animation Blending

## Description

Adds animation blending to Morrowind, enabling smooth transitions between animations. Where before a character would abruptly teleport from one animation pose to the next, now they will seamlessly move between them.

Animation blending is automatically applied to all npc, creature, and player animations. The look and timing of each transition can be adjusted via configuration files.

Compatible with all animation replacers, this mod serves as a purely visual effect and has no influence on gameplay mechanics or timings.

## Requirements

Requires an up-to-date version of MWSE, available at <https://mwse.github.io/MWSE/>.

## Installation

Extract the contents of the archive into your /Data Files/ directory.

## Modder Notes

This mod is inspired by and based on the OpenMW implementation by Max Yari. At the moment the OpenMW version is still under review, but hopefully by the time you read this it will have been approved and made available as a setting you can enable in the OpenMW launcher.

## Configuration

Configuration files are compatible between the two engines with some caveats:

1. OpenMW supports both `.json` and `.yaml` file formats, while MWSE only supports the `.json` format.

    If you want your configuration file to be usable by both engines you will need to convert any `.yaml` files to `.json` files. This can be done with a tool like <https://www.json2yaml.com/>.

2. OpenMW configuration supports "per-key" blending rules, while MWSE only supports "per-animation" blending rules.

    These rules are currently ignored by the MWSE implementation, but will not cause errors. You can safely include them for the benefit of OpenMW users.

Animation blending rules can be configured via `.json` files. 

The default blending rules (those applied automatically to npc, creature, and player animations) can be overridden by creating a configuration file at `Data Files/Animations/animation-config.json`.

Alternatively, you can configure blending rules on a per-asset basis by creating a corresponding `.json` file alongside the asset `.kf` (keyframes) file. For instance to override the blending rules of guars you would use `Data Files/Meshes/r/xguar.json`, which corresponds to the keyframes file `Data Files/Meshes/r/xguar.kf`. 

Providing per-asset overrides as described above allows animation blending to be applied to environmental objects (like activators or containers) which do not automatically receive blending by default.

The contents of configuration files must conform to the following format:

```json
{
  "blending_rules": [
    {
      "from": "*",
      "to": "*",
      "easing": "sineOut",
      "duration": 0.25
    },
    {
      "from": "idle",
      "to": "idleSneak",
      "easing": "springOutWeak",
      "duration": 0.4
    }
  ]
}
```

All blending rules are required to be inside the `blending_rules` array. 

Blending rules positioned later in the array override those positioned before them.

Each blending rule must provide the following fields:

- **from** *(string) Specifies the animation group that is being transitioning from.*
- **to** *(string) Specifies the animation group that is being transitioning to.*
- **easing** *(string) Specifies the easing function to be used for the transition.*
- **duration** *(number) Specifies the duration of the transition.*

---

The **from/to** fields are case-insensitive and support using the asterisk symbol as a wildcard marker to target multiple animation groups. This symbol is only allowed at the front or end of the string.

Examples:

- Using `idle*` would match any animation group **beginning** with `idle`. Such as `idle`, `idle2`, `idleSneak`, and so on.

- Using `*knockout` would match any animation group **ending** with `knockout`. Such as `knockOut`, `deathKnockOut`, `swimKnockOut`, and so on.

- Using `*spell*` would match any animation group that **contains** the string `spell`. Such as `idleSpell`,  `spellCast`, `spellTurnLeft`, and so on.

- Using `*` by itself with no other text will match **all** animations groups.

---

The **easing** field is case-sensitive and must match one of the following:

* "linear"
* "sineOut"
* "sineIn"
* "sineInOut"
* "cubicOut"
* "cubicIn"
* "cubicInOut"
* "quartOut"
* "quartIn"
* "quartInOut"
* "springOutWeak"
* "springOutMed"
* "springOutStrong"
* "springOutTooMuch"

See <https://easings.net/> and the OpenMW documentation for more information on these.

---

The **duration** field can be set to zero to disable blending between the specified animation groups.

## CHANGE LOG

- Version 1.0
     Initial release.

## Permissions

All code and assets are free to use as you see fit.

## Extra Credits

Max Yari (https://www.nexusmods.com/users/11230608)
For creating the OpenMW Animation Blending feature which inspired this mod. Easing code and config structures were adapted from his work.

Hrnchamd (https://www.nexusmods.com/morrowind/users/843673)
For helping figure out some engine details and adding related data structures to MWSE for this mod to use.

Melchior Dahrk (https://www.nexusmods.com/morrowind/users/962116)
For creating the banner image and proof reading the documentation. 
