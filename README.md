# Seastead

Containerized development environment.

## Usage

`/root/rose_island` is seastead's default working directory, so if you wanted to use seastead to work on the contents of your local `development` directory, you would run:

```
docker run -it --name seastead --rm \
    -v ~/development:/root/rose_island \
    -v ~/.ssh:/root/.ssh:ro \
    seastead
```

Mounting your local `~/.ssh` to `seastead` helps when you want to `git clone` stuff in there.

## License

[MIT](https://opensource.org/licenses/MIT)
