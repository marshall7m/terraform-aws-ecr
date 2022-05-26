import pytest
import logging
import os
import glob
import json

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)


def tf_vars_to_json(tf_vars: dict) -> dict:
    for k, v in tf_vars.items():
        if type(v) not in [str, bool, int, float]:
            tf_vars[k] = json.dumps(v)

    return tf_vars


tf_dirs = [
    f"{os.path.dirname(__file__)}/fixtures/create_repo",
    f"{os.path.dirname(__file__)}/fixtures/import_repo",
]


@pytest.mark.parametrize("tf", tf_dirs, indirect=True)
def test_plan(tf, terraform_version):
    log.debug(f"Terraform plan:\n{tf.plan()}")


@pytest.mark.parametrize(
    "tf,trigger_build_paths,expected_file_paths",
    [
        pytest.param(
            tf_dirs[0],
            [f"{tf_dirs[0]}/files"],
            [
                os.path.basename(abs_path)
                for abs_path in glob.glob(f"{tf_dirs[0]}/files/*")
                + glob.glob(f"{tf_dirs[0]}/files/.*")
            ],
            id="directories",
        ),
        pytest.param(
            tf_dirs[0],
            [f"{tf_dirs[0]}/files/foo.txt"],
            ["foo.txt"],
            id="file_paths",
        ),
    ],
    indirect=["tf"],
)
def test_trigger_file_paths(
    tf, terraform_version, trigger_build_paths, expected_file_paths
):
    """Ensure module is able to handle directory and file trigger paths"""
    log.info("Running Terraform plan")
    plan = tf.plan(
        tf_vars=tf_vars_to_json({"trigger_build_paths": trigger_build_paths}),
        output=True,
    )
    actual_file_paths = list(
        [
            resource["values"]["triggers"].keys()
            for resource in plan.modules["module.mut_ecr_docker_img"]._raw[
                "resources"
            ]  # noqa: E501
            if resource["address"]
            == "module.mut_ecr_docker_img.null_resource.build"  # noqa: E501
        ][0]
    )

    log.info("Assert expected build paths to be in plan")
    assert sorted(actual_file_paths) == sorted(expected_file_paths)
