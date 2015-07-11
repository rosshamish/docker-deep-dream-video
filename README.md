# docker-deep-dream-video

#####[DeepDreamVideo](https://github.com/graphific/deepdreamvideo)-ready [docker](https://www.docker.com/) environment, to save you 8 hours of setup headaches. 

---

Get [docker](https://www.docker.com/)

Pull (download) the image from Dockerhub `$ docker pull rosshamish/deep-dream-generator-video`.

*parameter: ./some/path/DeepDreamVideo -- path to download DeepDreamVideo source code into*  
Clone [graphific/DeepDreamVideo](https://github.com/graphific/DeepDreamVideo) 

`$ git clone https://github.com/graphific/DeepDreamVideo ./some/path/DeepDreamVideo`

*parameter: ./some/path/DeepDreamVideo -- path that DeepDreamVideo source code is in*  
Run a container and start a shell in it 

`$ docker run -v ./some/path/DeepDreamVideo:/src -it rosshamish/docker-deep-dream-video:latest bash`

Hack away! Files inside the path `./some/path/DeepDreamVideo` will be available inside the container at `/src`, and changes will be visible without restarting the container.

`$              `

-----------

To use your GPU, do: (from [tleyden](https://tleyden.github.io/blog/2014/10/25/docker-on-aws-gpu-ubuntu-14-dot-04-slash-cuda-6-dot-5/))

```
$ DOCKER_NVIDIA_DEVICES="--device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm"
$ sudo docker run -ti $DOCKER_NVIDIA_DEVICES rosshamish/docker-deep-dream-video bash
```

Caffe models are in the container at `/models/`. Do `$ ls /models` to see what's available. 

To use your own Caffe models, mount your host machine's models directory as a volume `$ docker run -v ./some/path/DeepDreamVideo:/src -v ./some/path/models:/models -it rosshamish/docker-deep-dream-video:latest bash`. Your models will be accessible in the container at `/models`.

Environment includes Caffe GPU support:  
Makefile.config:
```
# CPU-only switch (uncomment to build without GPU support).
# CPU_ONLY := 1
```

