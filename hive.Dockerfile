FROM bde2020/hive:2.3.2-postgresql-metastore

ENV ATLAS_HIVE_HOOK_HOME /opt/atlas-hive-hook

#Add atlas hive hook jars
ADD apache-atlas-hive-hook-2.1.0/hook/hive $ATLAS_HIVE_HOOK_HOME
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/atlas-application.properties $HIVE_HOME/conf
