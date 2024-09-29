====  My Jenkins Master  =====

sudo apt update

sudo apt upgrade -y

clear

<hr/>

sudo nano /etc/hostname

My-Jenkins-Master  
Bu ismi makineye ver.

Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


Makineyi yeniden başlat.

sudo init 6
sudo reboot

<hr/>

AWS web tarayıcısından Security groups'a gidip
8080 portunu dış dünyaya aç.

<hr/>


Java'yı kuracağız Jenkins için.

java -version

sudo apt install openjdk-21-jre -y

java --version



<hr/>


Jenkis'i kuracağız.
https://www.jenkins.io/doc/book/installing/linux/

<hr/>


sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install jenkins  -y

<hr/>


sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins

<hr/>


http://My-Jenkins-Master_makinesinin_public_IPsi_Public_IPv4_address:8080/


<hr/>

Jenkins'in admin parolası buradadır.

sudo cat  /var/lib/jenkins/secrets/initialAdminPassword


<hr/>



====  My Jenkins Agent  =====

sudo apt update

sudo apt upgrade -y

clear

<hr/>


sudo nano /etc/hostname

My-Jenkins-Agent  

Bu ismi makineye ver.


Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


Bu komutla da isimlendirmeyi yapabiliriz.

hostnamectl set-hostname My-Jenkins-Agent


<hr/>

Makineyi yeniden başlat.

sudo init 6

OR

sudo reboot

<hr/>



Java'yı kuracağız Jenkins için.

sudo apt install openjdk-21-jre -y

java --version

<hr/>

Docker'ı kuracağız.

sudo apt  install docker.io  -y

OR

sudo apt-get  install docker.io  -y

sudo usermod -aG docker $USER

sudo reboot


<hr/>





My Jenkins Agent için

sudo nano /etc/ssh/sshd_config

<hr/>

Bunların önündeki # sembolü kaldır.

PubkeyAuthentication yes

AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2

<hr/>

Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


sudo service ssh reload


<hr/>





My Jenkins Master için

sudo nano /etc/ssh/sshd_config


Bunların önündeki # sembolü kaldır.

PubkeyAuthentication yes

AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2


Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


sudo service ssh reload


ssh-keygen

OR

ssh-keygen -t ed25519


Master makinedeki id_ed25519.pub dosyasına çift tıkla
içindekini kopyala

Agent makinedeki authorized_keys dosyasına çift tıkla
bunun içine yapıştır ve kaydet


Master ve Agent makinelerini yeniden başlat.

sudo reboot

<hr/>


Master makinede
Jenkins'in admin parolası buradadır.

sudo cat  /var/lib/jenkins/secrets/initialAdminPassword


<hr/>

Agent makineyi node olarak Jenkins Master'a ekliyoruz.

Dashboard ->  Manage Jenkins -> Nodes  -> New Node


<hr/>

Bu adresi aç.
https://github.com/settings/tokens

GitHub Token oluştur.

<hr/>

MyGitHubTokenForAWS2024
ghp_123456789


Token'ı Jenkins'e tanıt.

Dashboard -> Manage Jenkins -> Credentials



<hr/>

====  My SonarQube  =====

sudo apt update

sudo apt upgrade -y

clear




sudo nano /etc/hostname

My-SonarQube  
Bu ismi makineye ver.

Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


Bu komutla da isimlendirmeyi yapabiliriz.

hostnamectl set-hostname My-SonarQube


Makineyi yeniden başlat.

sudo init 6

OR

sudo reboot



<hr/>


PostgreSQL kurulumu

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null


sudo apt update

sudo apt-get -y install postgresql postgresql-contrib

sudo systemctl enable postgresql


sudo passwd postgres

parola: 123456789



su - postgres

parola: 123456789

createuser sonar

psql

ALTER USER sonar WITH ENCRYPTED password 'sonar';

CREATE DATABASE sonarqube OWNER sonar;

grant all privileges on DATABASE sonarqube to sonar;

\q

exit





<hr/>


Adoptium repository

sudo bash

wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list





<hr/>

Adoptium repository

sudo bash

wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list


sudo apt update

sudo apt install openjdk-17-jre -y

OR

sudo apt install temurin-17-jdk -y


sudo update-alternatives --config java

java --version



<hr/>

Linux kernel

sudo vim /etc/security/limits.conf

Bir şey eklemek için önce klavyeden i tuşuna bas.

sonarqube   -   nofile   65536
sonarqube   -   nproc    4096


çıkış için ESC tuşuna bas.
:wq  yaz



<hr/>

sudo vim /etc/sysctl.conf

Bir şey eklemek için önce klavyeden i tuşuna bas.
Eklenecek bilgi aşağıdaki satır.

vm.max_map_count = 262144


Çıkış için ESC tuşuna bas.
:wq  yaz

<hr/>

Makineyi yeniden başlat.

sudo init 6

OR

sudo reboot

<hr/>


Sonarqube kurulumu

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip

sudo apt install unzip

sudo unzip sonarqube-10.6.0.92116.zip -d/opt

pwd

sudo mv   /opt/sonarqube-10.6.0.92116    /opt/sonarqube


<hr/>

sonar kullanıcı oluşturulacak ve haklar verilecek


sudo groupadd sonar

sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar

sudo chown sonar:sonar /opt/sonarqube -R

<hr/>

veritabanıyla bu kullanıcıyı konuştur

sudo vim /opt/sonarqube/conf/sonar.properties

sonar.jdbc.username=sonar
sonar.jdbc.password=sonar

sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube



<hr/>




Sonar servisini oluşturacağız.

sudo vim /etc/systemd/system/sonar.service

<hr/>
Aşağıdaki kodları olduğu gibi bu dosyanın içine yapıştır.

<hr/>

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target


<hr/>

Makine açıldığında sonarqube otomatik olarak çalıştırma komutları

sudo systemctl enable sonar

sudo systemctl start sonar

sudo systemctl status sonar

<hr/>
Log takibi

sudo tail -f /opt/sonarqube/logs/sonar.log

<hr/>

Makinenin public ip değerini al ve 9000 portundan giriş yap.
kullanıcı: admin
parola: admin


<hr/>

Jenkins için token oluştur.

Administrator  -> Security

http://MAKINENIN_PUBLIC_IP_DEGERI:9000/account/security

<hr/>

jenkins-sonarqube-token
sqa_123456789


Jenkins içinde tokenı kaydettir.

Pluginleri kur.

Sonar'ın kurulduğu makinenin Private IPv4 addresses değerini kopayla.

<hr/>

Docker Hub Token oluştur.

docker login -u YOUR_USERNAME  -p  dckr_pat_123456789


Jenkinse DockerHub Token'ı tanıt ekle.

<hr/>

Agent makinesi zamanla dolacak. Docker şişecek dolacak. Temizlik yapmanız lazım.
Agent makinede temizlik için yeriniz azalmışsa şu komutları kulanın lütfen.

docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'devops-003-pipeline-aws')

docker container rm -f $(docker container ls -aq)

docker volume prune

