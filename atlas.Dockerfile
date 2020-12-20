FROM sburn/apache-atlas

#Add atlas hive hook jars
ADD conf/atlas-application.properties /opt/apache-atlas-2.1.0/conf
