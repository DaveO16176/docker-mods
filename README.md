# MediaDC - Docker mod for nextcloud

This mod adds the required and optional packages the [MediaDC](https://apps.nextcloud.com/apps/mediadc) nextcloud app needs to work. Optional dependency Scipy is only installed on x86_64 as there are no wheels available for arm64v8.

In nextcloud docker arguments, set an environment variable `DOCKER_MODS=linuxserver/mods:nextcloud-mediadc`

If adding multiple mods, enter them in an array separated by `|`, such as `DOCKER_MODS=linuxserver/mods:nextcloud-mediadc|linuxserver/mods:nextcloud-mod2`
