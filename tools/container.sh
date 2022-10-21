docker run \
    --rm \
    -it \
    --name game-server-dev \
    -v $PWD/examples:/game-server/examples \
    -v $PWD/lualib:/game-server/lualib \
    -v $PWD/service:/game-server/service \
    -v $PWD/tools:/game-server/tools \
    -v $PWD/conf:/game-server/conf \
    -v $PWD/wcache:/game-server/wcache \
    game-server /bin/sh
