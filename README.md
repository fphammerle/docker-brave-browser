# Brave Browser Container Image 🐳

## Setup

In the following instructions, `podman` may be replaced with `sudo docker`.

### Step 1: Select or Build Image

Perform **one** of the following steps:
- ```sh
  $ git clone https://github.com/fphammerle/docker-brave-browser
  $ cd docker-brave-browser
  $ podman build -t [IMAGE_NAME] .
  ```
- Select a pre-built image at https://hub.docker.com/r/fphammerle/brave-browser/tags<br>
  (e.g., `docker.io/fphammerle/brave-browser:0.2.0-browser1.22.71-amd64`)

### Step 2: Start Dedicated X Server

Choose some arbitrary `[DISPLAY_NUMBER]` and run:
```sh
$ Xephyr -resizeable :[DISPLAY_NUMBER]
# for example:
$ Xephyr -resizeable :1
```

Alternative: Adapt the access rights of your main X server<br>
(cave: `xhost +` is horribly insecure)

### Step 3: Launch Container

```sh
$ podman run --name brave_browser --rm --init \
    -e DISPLAY=:[DISPLAY_NUMBER] -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v brave_browser_home:/home/browser --shm-size 1GB \
    --read-only --cap-drop ALL --security-opt no-new-privileges \
    [IMAGE_NAME]
```

Add `--tmpfs /tmp:size=8k` when using `docker`.
