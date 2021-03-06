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

## `experiment-4`

Build platform (https://search.maven.org/artifact/com.swirlds/swirlds-platform)

* multi-module build
* complex project


### Observations

* Timestamps seem to be set to seconds since epic but are sensitive to the
  timezone of the system. Resetting the timezone seems to fix this, and
  I am guessing it is an issue w/ the build
* module-info.java issues: https://issues.apache.org/jira/browse/MJAR-275
** Rebuild w/ early access JDK18 appears to fix this, however the .jar files themselves
   appear to also contain a timestamp. I expect this is due to how they are being
   'deployed' by file system copy.

### Conclusion

* JDK9-JDK17 artifacts cannot be built bit for bit identically if they are
  using module-info.java due to limitations of the JDK. JDK 18 contains fixes to address
  these

## `experiment-5`

Run on windows!

### Observations

Line endings are different. This matches advice from maven guide
(https://maven.apache.org/guides/mini/guide-reproducible-builds.html)

> Generally give different results on Windows and Unix because of different newlines. (carriage return linefeed on Windows, linefeed on Unixes)

### Conclusion
 * Windows and nix derivatives cannot build bit for bit identical copies of the same binary


## `experiment-6`

Docker

### Observations

Dates are wrong

### Conclusion

Docker can built artifacts w/ different timestamps on file resulting in different images

