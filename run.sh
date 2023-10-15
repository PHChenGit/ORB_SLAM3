xhost +local:root

XAUTH=/tmp/.docker.xauth

docker run -it \
    --env="DISPLAY=unix$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$XAUTH:$XAUTH" \
    --volume="$(pwd):/orb_slam3/" \
    --net=host \
    --privileged \
    --gpus all \
    tokohsun/orb-slam3:1.0.0 \
    /bin/bash

echo "Done!!"