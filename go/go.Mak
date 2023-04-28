BINARY_NAME=main.out

all: build test

build:
    go build -o ${BINARY_NAME} main.go

test:
    go test -v main.go

run:
    go build -o ${BINARY_NAME} main.go
    ./${BINARY_NAME}

clean:
    go clean
    rm ${BINARY_NAME}

# https://gist.github.com/thomaspoignant/5b72d579bd5f311904d973652180c705#file-makefile
