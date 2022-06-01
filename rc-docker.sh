sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-get update
sudo apt -y install docker-ce
sudo service docker start
read -p "Do you want to also install Rocket.Chat.Metrics? (y/N)" yn

if [[ ! $yn =~ ^[Yy]$ ]]
then
    curl -L https://s3.eu-west-1.amazonaws.com/rui.fernandes.public/rocketchat/docker/docker-compose.yml -o docker-compose.yml
    mkdir data
else
    git clone https://github.com/RocketChat/Rocket.Chat.Metrics ./Rocket.Chat.Metrics
	mv ./Rocket.Chat.Metrics/* .
	rm ./config/prometheus/prometheus.yml
	curl -L https://s3.eu-west-1.amazonaws.com/rui.fernandes.public/rocketchat/docker/prometheus.yml -o ./config/prometheus/prometheus.yml
	curl -L https://s3.eu-west-1.amazonaws.com/rui.fernandes.public/rocketchat/docker/docker-compose-promgraf.yml -o docker-compose.yml
fi

sudo chmod -R 777 ./data
#sudo docker-compose up -d

if [[ $yn =~ ^[Yy]$ ]]
then
	echo "WARNING: AFTER STARTING YOU WILL NEED TO ENABLE PROMETHEUS IN ROCKET.CHAT ADMINISTRATION LOGS"
fi
