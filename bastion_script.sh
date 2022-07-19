export BASTION_USER=ec2-user
export BASTION_HOST=ec2-54-254-134-87.ap-southeast-1.compute.amazonaws.com
export REDSHIFT_HOST=ldi-redshift-qa.chkfbg3jrkto.ap-southeast-1.redshift.amazonaws.com


# ssh -i /path/my-key-pair.pem username@instance-id -L localport:targethost:destport
# ssh -l $BASTION_USER $BASTION_HOST -p 22 -N -C -L "5439:${REDSHIFT_HOST}:5439";
# ssh -i "~/Git/bastion/ec2-bastion-keypair.pem" ec2-user@ec2-13-213-13-229.ap-southeast-1.compute.amazonaws.com  -L 5439:${REDSHIFT_HOST}:5439
ssh -i "~/Git/bastion/ec2-bastion-keypair.pem" ec2-user@ec2-13-213-13-229.ap-southeast-1.compute.amazonaws.com -p 22 -N -C -L 5439:${REDSHIFT_HOST}:5439


INSTANCE_ID=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=bastion-redshift" --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" --output text)

aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["5439"],"localPortNumber":["5439"]}'
