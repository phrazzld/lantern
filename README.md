# Seastead

Containerized development environment.

## Usage

`/root/respubliko` is seastead's default working directory, so if you wanted to use seastead to work on the contents of your local `development` directory, you would run:

```
docker run -it --name seastead --rm \
    -v ~/development:/root/respubliko \
    -v ~/.ssh:/root/.ssh:ro \
    phrazzld/seastead:latest
```

Mounting your local `~/.ssh` to `seastead` helps when you want to `git clone` stuff in there.

## License

[MIT](https://opensource.org/licenses/MIT)
