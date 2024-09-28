====  My Jenkins Master  =====

sudo apt update

sudo apt upgrade -y

clear



sudo nano /etc/hostname

My-Jenkins-Master  
Bu ismi makineye ver.

Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


Makineyi yeniden başlat.

sudo init 6
sudo reboot


AWS web tarayıcısından Security groups'a gidip
8080 portunu dış dünyaya aç.



Java'yı kuracağız Jenkins için.
java -version
sudo apt install openjdk-21-jre -y
java --version





Jenkis'i kuracağız.
https://www.jenkins.io/doc/book/installing/linux/


sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins  -y



sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins


http://My-Jenkins-Master_makinesinin_public_IPsi_Public_IPv4_address:8080/



Jenkins'in admin parolası buradadır.
sudo cat  /var/lib/jenkins/secrets/initialAdminPassword





====  My Jenkins Agent  =====

sudo apt update

sudo apt upgrade -y

clear



sudo nano /etc/hostname

My-Jenkins-Agent  
Bu ismi makineye ver.

Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


Bu komutla da isimlendirmeyi yapabiliriz.

hostnamectl set-hostname My-Jenkins-Agent



Makineyi yeniden başlat.

sudo init 6

OR

sudo reboot




Java'yı kuracağız Jenkins için.
sudo apt install openjdk-21-jre -y
java --version


Docker'ı kuracağız.

sudo apt  install docker.io  -y
OR
sudo apt-get  install docker.io  -y

sudo usermod -aG docker $USER
sudo reboot







My Jenkins Agent için
sudo nano /etc/ssh/sshd_config

Bunların önündeki # sembolü kaldır.

PubkeyAuthentication yes

AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2


Ctrl + x 'e bas.
Onaylamak için Y harfine bas.
En sonda ise Enter'a bas.


sudo service ssh reload







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







Master makinede
Jenkins'in admin parolası buradadır.
sudo cat  /var/lib/jenkins/secrets/initialAdminPassword