
hylos-version = 0.0.1

.PHONY: all

%-image:
	docker build -t csm-adapt/sagittariidae-$*:$(hylos-version) $*

all: base-image cron-image service-image
