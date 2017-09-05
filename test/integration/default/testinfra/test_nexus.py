import testinfra


def test_service_is_running_and_enabled(Service):
    nexus = Service('nexus')
    assert kibana.is_running
    assert kibana.is_enabled
