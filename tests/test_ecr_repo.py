import pytest
import tftest
import os
import unittest
from cached_property import cached_property
from random import randint
import datetime
import uuid
import boto3

tf_root_dir = "../modules/ecr"

class TestTerraformAWSEcr(unittest.TestCase):

    def setUp(self):
        date = datetime.date.today()
        id = uuid.uuid1()
        test_name = f'test-{date}-{id}'
        self.tf_vars = {
            'create_repo': 'true',
            'ecr_repo_url_to_ssm': 'true',
            'name': test_name,
            'ssm_key': test_name
        }
        
        self.tf = tftest.TerraformTest(tfdir=tf_root_dir, env=self.tf_vars)

    @pytest.mark.skipif(os.getenv('SKIP_TEST_RUN') == True,
                    reason="Skipping test deployment")
    @cached_property
    def run(self):
        try:
            self.tf.setup()
            plan = self.tf.plan(tf_vars=self.tf_vars)
            self.tf.apply(tf_vars=self.tf_vars)
            output = self.tf.output()
        except Exception as e:
            print(e)
        finally:
            self.tf.destroy(tf_vars=self.tf_vars)

        return plan,output

    def test_output(self):
        _, output = self.run()
        self.assertIsNotNone(output['ecr_repo_url'])
        self.assertIsNotNone(output['ssm_arn'])
        self.assertIsNotNone(output['ssm_version'])

    def test_plan(self):
        plan, _ = self.run()
    
    def test_get_ecr_repo(self):
        ecr = boto3.client('ecr')
        response = ecr.describe_repositories(repositoryNames=[self.tf_vars['name']])
