import pytest
import logging
import os
import glob
from pprint import pformat
import uuid
import boto3
import json

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

def tf_vars_to_json(tf_vars: dict) -> dict:
    for k, v in tf_vars.items():
        if type(v) not in [str, bool, int, float]:
            tf_vars[k] = json.dumps(v)

    return tf_vars

os.environ['AWS_DEFAULT_REGION'] = os.environ['AWS_REGION']
tf_dir = f'{os.path.dirname(__file__)}/fixtures/ecr-docker-img'

def pytest_generate_tests(metafunc):
    
    if 'terraform_version' in metafunc.fixturenames:
        tf_versions = [pytest.param('latest')]
        metafunc.parametrize('terraform_version', tf_versions, indirect=True, scope='session', ids=[f'tf_{v.values[0]}' for v in tf_versions])

    if 'tf' in metafunc.fixturenames:
        metafunc.parametrize('tf', [tf_dir], indirect=True, scope='session')


def test_build(tf, terraform_version):
    '''Ensure module that the module pushed the image to the associated ECR repository'''
    log.info('Running Terraform apply')
    tf.apply(auto_approve=True)
    out = tf.output()
    
    ecr = boto3.client('ecr')

    response = ecr.batch_get_image(
        repositoryName=out['repo_name'],
        imageIds=[
            {
                'imageTag': out['tag']
            },
        ],
    )

    log.info('Assert image exists')
    assert len(response['images']) == 1


@pytest.mark.parametrize('trigger_build_paths,expected_file_paths', [
    pytest.param(
        [f'{tf_dir}/files'],
        [os.path.basename(abs_path) for abs_path in glob.glob(f'{tf_dir}/files/*') + glob.glob(f'{tf_dir}/files/.*')],
        id='directories'
    ),
    pytest.param(
        [f"{tf_dir}/files/foo.txt"],
        ["foo.txt"],
        id='file_paths'
    )
])
def test_trigger_file_paths(tf, terraform_version, trigger_build_paths, expected_file_paths):
    """Ensure module is able to handle directory and file trigger paths"""
    log.info('Running Terraform plan')
    plan = tf.plan(tf_vars=tf_vars_to_json({'trigger_build_paths': trigger_build_paths}), output=True)
    actual_file_paths = list([resource['values']['triggers'].keys() for resource in plan.modules["module.mut_ecr_docker_img"]._raw['resources'] if resource['address'] == 'module.mut_ecr_docker_img.null_resource.build'][0])
    
    log.info('Assert expected build paths to be in plan')
    assert sorted(actual_file_paths) == sorted(expected_file_paths)