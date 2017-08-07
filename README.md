# Nexus OSS Repository Saltstack Formula
This Saltstack formula will install Nexus OSS Repository onto any linux (tested with debian jessie).

**Requires Nexus Sonatype Version 3 and above.**

# Use
In your formula matching sls just add
```nexus```

# ToDos
    - Make certificates importable, official CA etc.
        - Make java keystore replaceable if changes in the pillar occur. delete old one etc.
    - Obscure password in jetty-https.xml
    - Make this formula updateable
        - Set the symlink to the new version
        - Do not touch the sonatype-work folder
    - Copylivedata
        - Problem that after running the copyjob, another salt-call has to be done, so that the configuration files will be created correctly.

# Guide
Questions regarding "how to configure nexus" take a look at the sonatype documentation website. http://books.sonatype.com/nexus-book/reference3/index.html

## Prerequisites
1.) Requires Java

2.) Knowledge in Nexus OSS

## States
The default state is `nexus` this one will install, configure and creates a systemd entry for nexus.
There is also `nexus.v3.copylivedata` which will copy data from another host, to this local system.

### nexus.v3.copylivedata
Needs an existing ssh key on the host system.

## Defaults
1.) HTTPS will be configured and a self signed certificate is going to be created.

2.) The passwords for the java keystore is **neither encrypted nor obscured** in the `jetty-https.xml`.

## Recommendations
1.) Run Nexus OSS behind a reverseproxy. No issues with the self signed certificate will occur.

### Variables
Every variable is setable. If nothing is specified in the pillar it will be set via the `defaults.yaml`.

## Pillar Data
Use the pillar.example, every variable is commented.

## File Structure
Nexus OSS can be installed anywhere on linux. Per default it will be installed onto `/opt` the following directories will be created

`nexus` is a symlink pointing to the installed version. 

`nexus-versionnumber` is created while extracting, can be set via `install.path` in pillar

`sonatype-work` is created while extracting, can be set via `install.datapath` in pillar

### Configurationfiles
The following file will be created and modified via salt

`jetty-https.xml` used for https activation, stores the password to the java keystore

`nexus.properties` used for https activation, autoredirects, ssl and non ssl ports, and many more

`nexus.rc` used to run nexus as the specified user

`nexus.service` creates a systemctl entry, runs nexus as the specified user

`nexus.vmoptions` used to edit java vm preferences

# Version 2 

Formula to set up and configure a Sonatype Nexus server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``nexus``
---------

Downloads the tarball in version nexus:version (currently defaults to 2.8.0) from sonatype configured as either a pillar or grain. 
Then unpacks the archive into nexus:prefix (defaults to /srv/nexus).
Depends on the sun-java-formula for its JDK.

Tested on RedHat/CentOS 5.X or RedHat/CentOS 6.X.

