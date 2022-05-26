import pytest
import logging
import os
import boto3

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)


@pytest.mark.parametrize(
    "tf",
    [
        f"{os.path.dirname(__file__)}/fixtures/create_repo",
        f"{os.path.dirname(__file__)}/fixtures/import_repo",
    ],
    indirect=True,
)
def test_build(tf, terraform_version):
    """
    Ensure module that the module pushed the image to the
    associated ECR repository
    """
    log.info("Running Terraform apply")
    tf.apply(auto_approve=True)
    out = tf.output()

    ecr = boto3.client("ecr")

    response = ecr.batch_get_image(
        repositoryName=out["repo_name"],
        imageIds=[
            {"imageTag": out["tag"]},
        ],
    )

    log.info("Assert image exists")
    assert len(response["images"]) == 1
