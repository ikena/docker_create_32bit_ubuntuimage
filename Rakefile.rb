# coding:utf-8

desc "スクリプト取得"
task :get_script do
  #url = "https://github.com/docker/docker/raw/release-1.3/contrib/mkimage.sh"
  #sh "curl -LO #{url} "
  #sh "chmod 755 ./mkimage.sh"
  sh "git clone https://github.com/docker/docker.git"
end

desc "ビルド環境作成(rootパスワード必要)"
task :init do
  # 
  sh "sudo apt-get update"
  sh "sudo apt-get upgrade -y"
  sh "sudo apt-get clean"
  # Docker 
  sh "sudo apt-get install -y --no-install-recommends docker.io"
  sh "sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker"
  sh "sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io"
  # set user need not do sudo
  sh "sudo gpasswd -a ${USER} docker"
  sh "sudo service docker.io restart"

  # イメージ作成ツールのためのらいぶらり
  sh "sudo apt-get install -y --no-install-recommends debootstrap build-essential"
end


desc "Ubuntu 14.04 イメージ作成"
task :make_image do
  # fromを変えなくてよくて便利そうなので、公式のものと名前を合わせておくが、微妙に違いがあるとよけいややこしいかも。
  imagename = "ubuntu:14.04"
  cd "docker/contrib/" do
    sh "./mkimage.sh -t #{imagename} debootstrap --include=ubuntu-minimal --components=main,universe trusty"
  end
end

desc "不要なイメージ削除"
task :clean do
  sh "docker rm `docker ps -a -q`"
  sh "docker rmi $(docker images | awk '/^<none>/ { print $3 }')"
end

