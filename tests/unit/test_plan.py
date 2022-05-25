import pytest
import logging
import os

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

@pytest.mark.parametrize('tf', [f'{os.path.dirname(__file__)}/fixtures/repo', f'{os.path.dirname(__file__)}/fixtures/ecr-docker-img'], indirect=True)
@pytest.mark.parametrize('terraform_version', ['latest'], indirect=True)
def test_plan(tf, terraform_version):
    log.debug(f'Terraform plan:\n{tf.plan()}')