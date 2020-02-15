# Lantern

Containerized development environment.

## Usage

Make sure you've got `~/oa` on your host machine, then run:

```
docker run -it --name lantern --rm \
    -v ~/oa:/root/oa \
    -v ~/.ssh:/root/.ssh:ro \
    lantern
```

Mounting your local `~/.ssh` to `lantern` helps when you want to `git clone` stuff in there.

## License

[MIT](https://opensource.org/licenses/MIT)
