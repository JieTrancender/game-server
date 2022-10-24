docker run \
    --rm \
    -it \
    --name game-server-dev \
    -v $PWD/examples:/game-server/examples \
    -v $PWD/lualib:/game-server/lualib \
    -v $PWD/service:/game-server/service \
    -v $PWD/tools:/game-server/tools \
    -v $PWD/3rd:/game-server/3rd \
    -v $PWD/luaclib:/game-server/luaclib \
    game-server /bin/sh
