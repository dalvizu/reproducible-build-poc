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

**Proves:**

Maven is capable of running on the same inputs and producing a non
identical bit by bit .jar as output

## `experiment-1`

Follow guide:

https://maven.apache.org/guides/mini/guide-reproducible-builds.html

Add maven source plugin:

```
<plugin>
  <artifactId>maven-source-plugin</artifactId>
  <version>3..0</version>
</plugin>
```

Bump maven compiler plugin to 3..0:

```
<plugin>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3..0</version>
</plugin>
```

Define `project.build.outputTimestamp` property:

```
   <propertiesi>
     [...]
     <project.build.outputTimestamp>10</project.build.outputTimestamp>
   </properties>
```

run `./experiment.sh`

**Proves**

Maven is capable of making an identical bit-by-bit .jar when run on the same computer
with the same JDK


## `experiment-2`

TODO: Vagrant of different OS?






