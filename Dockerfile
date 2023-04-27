FROM codercom/code-server

ARG TARGETARCH=amd64

# Install dependencies
RUN sudo apt-get update -y && sudo apt-get install rsync hugo curl wget -y

# Install kubectl for the target architecture
RUN echo "Target architecture: $TARGETARCH" && \
    echo "URL: https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$TARGETARCH/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$TARGETARCH/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$TARGETARCH/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Install buildkitd for the target architecture
RUN BUILDKIT_VERSION="v0.11.6" && \
    curl -LO "https://github.com/moby/buildkit/releases/download/$BUILDKIT_VERSION/buildkit-$BUILDKIT_VERSION.linux-$TARGETARCH.tar.gz" && \
    tar -xvf buildkit-$BUILDKIT_VERSION.linux-$TARGETARCH.tar.gz && \
    sudo mv bin/* /usr/local/bin/

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
