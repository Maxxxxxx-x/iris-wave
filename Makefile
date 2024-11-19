#!make

bin_name = iris-wave
cmd_path = ./cmd/${bin_name}

.PHONY: tidy
tidy:
	go mod tidy
	go fmt ./...


.SILENT: clean
clean:
	if [ -d /tmp/bin/${bin_name} ]; then rm -rf /tmp/bin/${bin_name}; fi
	if [ -d ./tmp/ ]; then rm -rf ./tmp; fi
	if [ -d ./logs/ ]; then rm -rf ./logs; fi


.PHONY: build/prod
build/prod: clean
	go build -o=/tmp/bin/${bin_name} ${cmd_path}


.PHONY: build/test
build/test: clean
	go build -o=./tmp/bin/${bin_name} ${cmd_path}


.SILENT: prod
prod: build/prod
	@ /tmp/bin/${bin_name}


.SILENT: test
test: build/test
	@ ./tmp/bin/${bin_name}



