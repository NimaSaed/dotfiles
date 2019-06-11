sudo docker run \
-d \
--name plex \
-p 32400:32400/tcp \
-p 3005:3005/tcp \
-p 8324:8324/tcp \
-p 32469:32469/tcp \
-p 1900:1900/udp \
-p 32410:32410/udp \
-p 32412:32412/udp \
-p 32413:32413/udp \
-p 32414:32414/udp \
-e TZ="Malaysia" \
-e PLEX_CLAIM="claim-E143z7yGgWADZ1Ad7gpo" \
-e ADVERTISE_IP="http://192.168.0.193:32400/" \
-h 192.168.0.193 \
-v ~/Videos/.plex/config:/config \
-v ~/Videos/.plex/transcode:/transcode \
-v ~/Videos/:/data \
plexinc/pms-docker
