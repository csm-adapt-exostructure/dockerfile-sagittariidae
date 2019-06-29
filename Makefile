
image-group       := csm-adapt
image-name-prefix := sagittariidae
image-repo-prefix := $(image-group)/$(image-name-prefix)
image-version     := 0.0.1

images  = base cron service

.PHONY: all clean

all: $(foreach image,$(images),$(image)-image)

%-image:
	docker build -t $(image-repo-prefix)-$*:$(image-version) $*

clean:
	for image in $(images); do \
		docker rmi -f $(image-repo-prefix)-$${image}:$(image-version); \
	done
