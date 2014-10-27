apt-get install openjdk-7-jre-headless
sudo update-java-alternatives -s java-1.7.0-openjdk-amd64

cd /opt

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.2.zip
unzip elasticsearch-1.2.2.zip

wget http://download.elasticsearch.org/elasticsearch/marvel/marvel-latest.zip
bin/plugin --url file:/opt/elasticsearch-1.2.2/marvel-latest.zip --install marvel

./bin/elasticsearch -Xmx3000M -d

#watch -n1 "curl -XGET 'http://localhost:9200/_cluster/health?pretty=true'"

#bin/plugin --url file:/opt/elasticsearch/marvel-latest.zip --install marvel
#curl -XDELETE 'http://localhost:9200/*'
#curl -XPOST 'http://localhost:9200/_shutdown'


