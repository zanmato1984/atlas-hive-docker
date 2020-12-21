# Docker-compose for atlas managing hive metadata and lineage

## Prerequisite

### Build atlas

Download atlas source code:

```
git clone https://github.com/apache/atlas.git
cd atlas
```

Checkout version `release-2.1.0-rc3`:

```
git checkout release-2.1.0-rc3
```

Modify some code that conflicts with latest hive:

File `addons/hive-bridge/src/main/java/org/apache/atlas/hive/bridge/HiveMetaStoreBridge.java`, comment out line 577~581:

```
    public static String getDatabaseName(Database hiveDB) {
        String dbName      = hiveDB.getName().toLowerCase();
        // String catalogName = hiveDB.getCatalogName() != null ? hiveDB.getCatalogName().toLowerCase() : null;

        // if (StringUtils.isNotEmpty(catalogName) && !StringUtils.equals(catalogName, DEFAULT_METASTORE_CATALOG)) {
        //     dbName = catalogName + SEP + dbName;
        // }

        return dbName;
    }
```

Build:

```
mvn clean -DskipTests package -Pdist,embedded-hbase-solr
```

Copy necessary files into this project's root directory:

```
cp -r distro/target/apache-atlas-2.1.0-hive-hook/apache-atlas-hive-hook-2.1.0 <ROOT_OF_THIS_PROJECT>
```

### Make docker images

Use make:

```
make
```

## Run

### Start services

`cd` to this project's root directory, then start services using `docker-compose`:

```
docker-compose up -d
```

### Login atlas using Web UI

Open `http://localhost:21000` in your local browser, wait until you see the login page, use `admin` / `admin` to login.

### Run some hive `SQL`s

`bash` into the hive container:

```
docker-compose exec hive-server bash
```

Start beeline:

```
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

Run some statements containing certain lineage info, e.g.:

```
create table t(i int);
create view v as select * from t;
```

### Check lineage in Web UI

Now refresh the atlas Web UI page, you'll see a bunch of hive entities captured, each of which containing the lineage info.

## References

[Doc of atlas's hive hook](http://atlas.apache.org/index.html#/HookHive)

[Solving incompatibility between latest atlas and hive](https://liangjunjiang.medium.com/deploy-atlas-hive-hook-fcb130b7db01)

[Docker atlas](https://github.com/sburn/docker-apache-atlas)

[Docker hive](https://github.com/big-data-europe/docker-hive)
