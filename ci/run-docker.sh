set -ex

run() {
    # This directory needs to exist before calling docker, otherwise docker will create it but it
    # will be owned by root
    mkdir -p target

    docker build -t $1 ci/docker/$1
    docker run \
           --rm \
           --user $(id -u):$(id -g) \
           -e CARGO_HOME=/cargo \
           -e CARGO_TARGET_DIR=/target \
           -e TARGET=$1 \
           -e USER=$USER \
           -v $HOME/.cargo:/cargo \
           -v `pwd`/target:/target \
           -v `pwd`:/checkout:ro \
           -v `rustc --print sysroot`:/rust:ro \
           -w /checkout \
           -it $1 \
           bash -c "HOME=/tmp PATH=\$PATH:/rust/bin ci/run.sh"
}

if [ -z $1 ]; then
    for d in `ls ci/docker/`; do
        run $d
    done
else
    run $1
fi
