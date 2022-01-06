# reproducible-build-poc

Created from archetype command:

`mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4`

Update mvn compiler and mvn source versions

then `mvn wrapper:wrapper`

then add `jenv local 17.0.1` to lock java version

## `experiment-0/`

No changes 

```
mkdir -p results/
mvn clean install; cp target/*.jar results/1.jar
mvn clean install; cp target/*.jar results/2.jar` to produce results/2.jar
diffoscope results/1.jar results/2.jar > results/diffoscope-results.txt
```

Proves: mvn builds can be non deterministic

## `experiment-1`


