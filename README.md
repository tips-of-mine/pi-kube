
Pour démarrer et l'installation

cd /opt

curl https://raw.githubusercontent.com/tips-of-mine/pi-kube/master/kmaster-01-setup.sh | sh

cd /opt/pi-kube

Editer le fichier hosts

sudo nano /etc/hosts

On rajoute les lignes suivante (en fonctonne du nombre d'élèment que nous avons)
192.168.1.202	kmaster-02	kmaster-02.tips-of-mine.lan
192.168.1.203	kmaster-03	kmaster-03.tips-of-mine.lan
192.168.1.204	kworker-001	kworker-001.tips-of-mine.lan
192.168.1.205	kworker-002	kworker-002.tips-of-mine.lan
192.168.1.206	kworker-003	kworker-003.tips-of-mine.lan
192.168.1.207	kworker-004	kworker-004.tips-of-mine.lan
192.168.1.208	kworker-005	kworker-005.tips-of-mine.lan

Génèrer la clé

ssh-keygen

Copier la clé partout

sudo ssh-copy-id pi@kmaster-02
sudo ssh-copy-id pi@kmaster-03
sudo ssh-copy-id pi@kworker-001
sudo ssh-copy-id pi@kworker-002
sudo ssh-copy-id pi@kworker-003
sudo ssh-copy-id pi@kworker-004
sudo ssh-copy-id pi@kworker-005

Pour lancer l'installation

sudo ansible-playbook Install-Pi-kube.yml

La page d'accès pour HAproxy

http://192.168.1.201:8081/haproxy?stats

Pour remettre les raspberry en état après utilisation.

sudo ansible-playbook Uninstall-Pi-Kube.yml