# Nexus OSS Repository Saltstack Formula
This Saltstack formula will install Nexus OSS Repository onto any Linux (tested with Debian Jessie, CentOS 5, 6, 7).

**Requires Nexus Sonatype Version 3 and above.**

# Use
In your formula matching, SLS just add
```nexus```

# ToDos
    - Make certificates importable, official CA, etc.
        - Make java keystore replaceable if changes in the pillar occur. Delete old one etc.
    - Obscure password in jetty-https.xml
    - Make this formula updateable
        - Set the symlink to the new version
        - Do not touch the sonatype-work folder
    - Copylivedata
        - The problem that after running the copy job, another salt-call has to be done, so that the configuration files will be created correctly.

# Guide
Questions regarding "how to configure nexus" take a look at the Sonatype documentation website. http://books.sonatype.com/nexus-book/reference3/index.html

## Prerequisites
1.) Requires Java JRE

2.) Knowledge in Nexus OSS

## States
The default state is `nexus` this one will install, configure and creates a systemd entry for the nexus.
There is also `nexus.v3.copylivedata` which will copy data from another host to this local system.

### nexus.v3.copylivedata
Needs an existing ssh key on the host system.

## Defaults
1.) HTTPS will be configured, and a self-signed certificate is going to be created if `applicationportssl` is uncommented.

2.) The passwords for the Java keystore is **neither encrypted nor obscured** in the `jetty-https.xml`.

## Recommendations
1.) Run Nexus OSS behind a reverse proxy. No issues with the self-signed certificate will occur.

### Variables
Every variable is settable. If nothing is specified in the pillar, it will be set via the `defaults.yaml`.

## Pillar Data
Use the pillar.example, every variable is commented.

## File Structure
Nexus OSS can be installed anywhere on Linux. Per default it will be installed onto `/opt` the following directories will be created

`nexus` is a symlink pointing to the installed version. 

`nexus-versionnumber` is created while extracting, can be set via `install.path` in the pillar

`sonatype-work` is created while extracting, can be set via `install.datapath` in pillar symlink in `install.path` will be created

### Configurationfiles
The following file will be created and modified via salt

`jetty-https.xml` used for https activation, stores the password to the Java keystore

`nexus.properties` used for https activation, auto-redirects, SSL and non-SSL ports, and many more

`nexus.rc` used to run nexus as the specified user

`nexus.service` creates a systemctl entry, runs nexus as the specified user

`nexus.vmoptions` used to edit java vm preferences

# Plugins
A plugins can be loaded if they are specified in the pillar under `nexus.plugins`.

```
For now, only support for nexus-repository-apt is done, feel free to use it as a template for other ones.
Be aware of plugin version compatibility with your installed version!
```
nexus-repository-apt:
Compile plugin it as it is mentioned [here](https://github.com/sonatype-nexus-community/nexus-repository-apt)
Point your pillar `nexus.plugins.nexus_repository_apt.path` to it.




# Version 2 

Formula to set up and configure a Sonatype Nexus server.

## note

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

## Available states
    contents:
        local:
            - ``nexus``

Downloads the tarball in version nexus:version (currently defaults to 3.11.0-01) from sonatype configured as either a pillar or grain. 
Then unpacks the archive into nexus:prefix (defaults to /opt/nexus).
Depends on the sun-java-formula for its JDK/JRE. Tested with jre1.8.0_172.
