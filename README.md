
cd /opt

curl https://raw.githubusercontent.com/tips-of-mine/pi-kube/master/kmaster-01-setup.sh | sh

cd /opt/pi-kube

sudo nano /etc/hosts

192.168.1.202	kmaster-02	kmaster-02.tips-of-mine.lan
192.168.1.203	kmaster-03	kmaster-03.tips-of-mine.lan
192.168.1.204	kworker-001	kworker-001.tips-of-mine.lan
192.168.1.205	kworker-002	kworker-002.tips-of-mine.lan
192.168.1.206	kworker-003	kworker-003.tips-of-mine.lan
192.168.1.207	kworker-004	kworker-004.tips-of-mine.lan
192.168.1.208	kworker-005	kworker-005.tips-of-mine.lan

ssh-keygen

sudo ssh-copy-id pi@kmaster-02
sudo ssh-copy-id pi@kmaster-03
sudo ssh-copy-id pi@kworker-001
sudo ssh-copy-id pi@kworker-002
sudo ssh-copy-id pi@kworker-003
sudo ssh-copy-id pi@kworker-004
sudo ssh-copy-id pi@kworker-005

sudo ansible-playbook Install-Pi-kube.yml