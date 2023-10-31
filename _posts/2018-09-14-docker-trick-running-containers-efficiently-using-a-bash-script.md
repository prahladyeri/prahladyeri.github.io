---
layout: post
title: 'Docker trick: Running containers efficiently using a bash script'
tags: docker linux technology
---

One of the basic problems with running a docker image is that its too easy to spew up multiple instances or containers of the same image. Consider running the following container for instance:

    docker run -it -e AWS_ACCESS_KEY_ID="test" -e AWS_SECRET_ACCESS_KEY="test" \
    --net=host "prahladyeri/testimage:latest" /bin/bash


This will start a fresh container instance from image **prahladyeri/testimage:latest** and you may optionally pass environment variables (using -e switch), and the /bin/bash argument to manually trigger a command inside the container instead of running the default one. However, once you exit the container, you don't have any control over that container *instance*. Running the same "docker run" command as above is just going to spew another container instance for the same image, while the old one still stays in memory. Repeating this process multiple times is a wastage of invaluable memory and cores which isn't the goal of using docker at all!

![docker-logo](/uploads/2018/09/docker-logo-300x232.png){.alignnone .size-medium .wp-image-1073 width="300" height="232"}

A more efficient way of handling things is to check the existence of a container instance already running for the image, and restart that one if required:

    docker ps -a -f "ancestor=prahladyeri/testimage:latest" -q -l
    f7261ea890ce

The above command returns the id of an already running container (if any), so using that you can just restart that same container without passing all the parameters again as follows:

    docker start -i f7261ea890ce

Of course, you can automate this whole process by writing a single bash script called *start\_container:*

```bash
#!/bin/bash
imgname="prahladyeri/testimage:latest"
imgid=$(docker ps -a -f "ancestor=$imgname" -q -l)

if [ -z "$imgid" ]; then
  echo "creating new instance for $imgname"
  docker run -it -e AWS_ACCESS_KEY_ID="test" -e AWS_SECRET_ACCESS_KEY="test" --net=host "$imgname" /bin/bash
else
  echo "instance found"
  docker start -i $(docker ps -a -f "ancestor=$imgname" -q -l)
fi
```

Just replace the \$*imgname* variable with that of your own image name, and pass any arguments you want (for example, ***-e AWS\_KEY\_ID***) to the container on line 7. This script will start a new container only if none are found already, otherwise, it will just restart an existing one!

Hope you find this useful.
