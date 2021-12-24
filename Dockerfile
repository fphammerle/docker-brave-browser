FROM docker.io/debian:11.2-slim

# manually installing libgl1 to fix some browser crashes
# and to reduce ubiquitous "Aw, Snap!" errors ("Error code: 6"):
# > [[...]:angle_platform_impl.cc(43)] Display.cpp:833 (initialize): ANGLE Display::initialize error 12289: Could not dlopen libGL.so.1: [...]
# > [[...]:gl_surface_egl.cc(773)] EGL Driver message (Critical) eglInitialize: Could not dlopen libGL.so.1: [...]
# > [[...]:gl_surface_egl.cc(1322)] eglInitialize OpenGL failed with error EGL_NOT_INITIALIZED, trying next display type
# > [[...]:gl_initializer_linux_x11.cc(160)] GLSurfaceEGL::InitializeOneOff failed.
# > [[...]:viz_main_impl.cc(150)] Exiting GPU process due to errors during initialization

# https://brave.com/linux/#release-channel-installation
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        fonts-tlwg-loma-ttf \
        gnupg \
        libgl1 \
    && apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys D8BAD4DE7EE17AF52A834B2D0BB75829C2D4E821 \
    && rm -rf /var/lib/apt/lists/* \
    && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list \
    && useradd --create-home browser

ARG BRAVE_BROWSER_PACKAGE_VERSION=1.31.87
RUN apt-get update \
    && apt-cache policy brave-browser \
    && apt-get install --yes --no-install-recommends \
        brave-browser=$BRAVE_BROWSER_PACKAGE_VERSION \
    && rm -rf /var/lib/apt/lists/* \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \;

USER browser
VOLUME /home/browser
# --disable-dev-shm-usage to fix some "Aw, Snap!" errors and video playback,
# apparently by resolving:
# > ERROR:broker_posix.cc(46)] Received unexpected number of handles
# https://github.com/WPO-Foundation/wptagent/issues/327#issuecomment-614086842
CMD ["brave-browser", "--no-sandbox"]

# mounts tmpfs at /tmp implicitly
LABEL podman-run-x11="podman run --name brave_browser --rm --init -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v brave_browser_home:/home/browser --shm-size 1GB --read-only --cap-drop ALL --security-opt no-new-privileges \${IMAGE}"

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="brave browser" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-brave-browser" \
    org.opencontainers.image.revision="$REVISION"
