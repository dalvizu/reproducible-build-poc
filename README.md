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

### Observations

diffoscope reveals timestamps and bits within the archive are a little different: both
`.class` files and `META-INF/*` files are different - presumably this is timestamped
data. Additionally the 'zipinfo' file contains timestamps.

### Conclusions

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

### Observations

Both produced artifacts are bit by bit identical copies

### Conclusion

Maven is capable of making an identical bit-by-bit .jar when run on the same computer
with the same JDK, when that archive contains a single class file.


## `experiment-2`

This experiment compared the build on two different computers
with two different kernels and chipsets:

  * an Ubuntu 20.04 OS with amd64 CPU architecture
  * a macbook with m1 arm cpu

Additionally, two files were added (App2.java App3.java).

Steps:

```
brew install vagrant
vagrant plugin install vagrant-exec
vagrant plugin install vagrant-scp
gcloud auth application-default login
vagrant up
./experiment.sh
vagrant destroy --force
```

### Observations

Both produced artifacts are bit by bit identical copies

### Conclusion

Maven is capable of making an identical bit-by-bit .jar when run on
different unix derivative OS and similar versions of the JDK
on a simple application

## `experiment-3`

Different versions of JDK

Macbook:
```
openjdk version "11.0.12" 2021-07-20
OpenJDK Runtime Environment Homebrew (build 11.0.12+0)
OpenJDK 64-Bit Server VM Homebrew (build 11.0.12+0, mixed mode)
```

Ubuntu:
```
openjdk version "17" 2021-09-14
OpenJDK Runtime Environment (build 17+35-2724)
OpenJDK 64-Bit Server VM (build 17+35-2724, mixed mode, sharing)
```

### Observations

Both produced artifacts are bit by bit identical copies

### Conclusion

Maven is capable of making an identical bit-by-bit .jar when run on
different versions of OpenJDK
