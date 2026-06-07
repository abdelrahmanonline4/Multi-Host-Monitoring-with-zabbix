Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  ## DB VM 
  config.vm.define "db01" do |db01|
    db01.vm.box = "eurolinux-vagrant/centos-stream-9"
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: "192.168.56.15"
    db01.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end

    # Provisioning with setup_mariadb.sh script
    db01.vm.provision "shell", path: "mariadb.sh", privileged: true
    db01.vm.provision "shell", inline: <<-SHELL
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest.el9.noarch.rpm

dnf clean all

dnf install zabbix-agent2 -y

sed -i 's/^Server=.*/Server=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^ServerActive=.*/ServerActive=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^Hostname=.*/Hostname=db01/' \
/etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload
SHELL
  end

  # Memcache VM
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = "eurolinux-vagrant/centos-stream-9"
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: "192.168.56.14"
    mc01.vm.provider "virtualbox" do |vb|
      vb.memory = "900"
    end

    # Provisioning with setup_memcached.sh script
    mc01.vm.provision "shell", path: "memcached.sh", privileged: true
    mc01.vm.provision "shell", inline: <<-SHELL
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest.el9.noarch.rpm

dnf clean all

dnf install zabbix-agent2 -y

sed -i 's/^Server=.*/Server=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^ServerActive=.*/ServerActive=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^Hostname=.*/Hostname=mc01/' \
/etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload
SHELL
  end

  # RabbitMQ VM
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = "eurolinux-vagrant/centos-stream-9"
    rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: "192.168.56.13"
    rmq01.vm.provider "virtualbox" do |vb|
      vb.memory = "600"
    end

    # Provisioning with setup_rabbitmq.sh script
    rmq01.vm.provision "shell", path: "rabbitmq.sh", privileged: true
    rmq01.vm.provision "shell", inline: <<-SHELL
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest.el9.noarch.rpm

dnf clean all

dnf install zabbix-agent2 -y

sed -i 's/^Server=.*/Server=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^ServerActive=.*/ServerActive=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^Hostname=.*/Hostname=rmq01/' \
/etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload
SHELL
  end

  # Tomcat VM
  config.vm.define "app01" do |app01|
    app01.vm.box = "eurolinux-vagrant/centos-stream-9"
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: "192.168.56.12"
    app01.vm.provider "virtualbox" do |vb|
      vb.memory = "4200"
    end

    # Provisioning with setup_tomcat.sh script
    app01.vm.provision "shell", path: "tomcat.sh", privileged: true
    app01.vm.provision "shell", inline: <<-SHELL
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest.el9.noarch.rpm

dnf clean all

dnf install zabbix-agent2 -y

sed -i 's/^Server=.*/Server=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^ServerActive=.*/ServerActive=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^Hostname=.*/Hostname=app01/' \
/etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload
SHELL
  end

  # Nginx VM
  config.vm.define "web01" do |web01|
    web01.vm.box = "ubuntu/jammy64"
    web01.vm.hostname = "web01"
    web01.vm.network "private_network", ip: "192.168.56.11"
    web01.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "800"
    end

    # Provisioning with setup_nginx.sh script
    web01.vm.provision "shell", path: "nginx.sh", privileged: true
    web01.vm.provision "shell", inline: <<-SHELL
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb

dpkg -i zabbix-release_latest_7.0+ubuntu22.04_all.deb

apt update

apt install zabbix-agent2 -y

sed -i 's/^Server=.*/Server=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^ServerActive=.*/ServerActive=192.168.56.10/' \
/etc/zabbix/zabbix_agent2.conf

sed -i 's/^Hostname=.*/Hostname=web01/' \
/etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

ufw allow 10050/tcp || true
SHELL
  end

  # Zabbix Server VM
config.vm.define "zbx01" do |zbx01|
  zbx01.vm.box = "eurolinux-vagrant/centos-stream-9"
  zbx01.vm.hostname = "zbx01"
  zbx01.vm.network "private_network", ip: "192.168.56.10"

  zbx01.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
  end

  zbx01.vm.provision "shell", path: "zabbix-server.sh", privileged: true
end
end
