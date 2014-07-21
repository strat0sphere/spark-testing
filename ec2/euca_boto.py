#!/usr/bin/env python

import os
import boto
from boto.ec2.regioninfo import RegionInfo
euca_ec2_host="eucalyptus.race.cs.ucsb.edu"
euca_id=os.getenv('AWS_ACCESS_KEY')
euca_key=os.getenv('AWS_SECRET_KEY')
euca_region = RegionInfo(name="eucalyptus", endpoint=euca_ec2_host)
ec2conn = boto.connect_ec2(
    aws_access_key_id=euca_id,
    aws_secret_access_key=euca_key, 
    is_secure=False,
    port=8773, 
    path="/services/Eucalyptus", 
    region=euca_region)
print ec2conn.get_all_zones()
