import testinfra


def test_package_in_installed(Package):
    nexus = Package('nexus')
    assert nexus.is_installed
    assert nexus.version.startswith('5.')

def test_service_is_running_and_enabled(Service):
    nexus = Service('nexus')
    assert kibana.is_running
    assert kibana.is_enabled
