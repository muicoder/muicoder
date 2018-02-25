INSTALL BASH COMPLETION ON COREOS
---

__直接登入系统：__
开机启动时（按e）加上内核启动参数：`coreos.autologin`

使用 toolbox 安装，输入以下内容开始自动安装。。。

```bash
bashrc=$(readlink ~/.bashrc) || bashrc=/usr/share/skel/.bashrc; rm -f ~/.bashrc && cp $bashrc ~/.bashrc
cat >> ~/.bashrc <<- \EOF
up-docker-bash () {
    toolbox -c "cat /etc/os-release \
    && curl -fsSL https://github.com/docker/cli/raw/master/contrib/completion/bash/docker -o /usr/share/bash-completion/completions/docker \
    && curl -fsSL https://github.com/docker/compose/raw/master/contrib/completion/bash/docker-compose -o /usr/share/bash-completion/completions/docker-compose \
    && curl -fsSL https://github.com/docker/machine/raw/master/contrib/completion/bash/docker-machine.bash -o /usr/share/bash-completion/completions/docker-machine \
    && curl -fsSL https://github.com/docker/machine/raw/master/contrib/completion/bash/docker-machine-prompt.bash -o /usr/share/bash-completion/completions/docker-machine-prompt \
    && curl -fsSL https://github.com/docker/machine/raw/master/contrib/completion/bash/docker-machine-wrapper.bash -o /usr/share/bash-completion/completions/docker-machine-wrapper \
    && cp -ru /usr/share/bash-completion/ /media/root/var/ \
    ;clear" && source /var/bash-completion/bash_completion
}

if [[ -f /var/bash-completion/bash_completion ]] ; then
    . /var/bash-completion/bash_completion
else
    path=/opt/bin
    sudo mkdir --parents $path; sudo chown --recursive $USER:$USER /opt
    #安装 docker-compose 最新构建版本
    [[ $(docker-compose version) ]] || ( curl -fSL https://dl.bintray.com/docker-compose/master/docker-compose-Linux-x86_64 -o $path/docker-compose && chmod +x $path/docker-compose )
    toolbox dnf install -y bash-completion && up-docker-bash
fi
export DOCKER_HIDE_LEGACY_COMMANDS=true
EOF

source ~/.bashrc
```