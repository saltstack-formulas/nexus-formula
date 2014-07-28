=====
nexus
=====

Formula to set up and configure a Sonatype Nexus server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``nexus``

Downloads the tarball in version nexus:version (currently defaults to 2.8.0) from sonatype configured as either a pillar or grain. 
Then unpacks the archive into nexus:prefix (defaults to /srv/nexus).
Depends on the sun-java-formula for its JDK.

Tested on RedHat/CentOS 5.X or RedHat/CentOS 6.X.

