# aws-assume_role-cred
Setting AWS Assume Role Credential

## How to use.
```
# 
ruby ./set_assume_role_cred.rb -a {AWS Acount} -r {Role} -u {username} -m {MFA TOKEN}

#EX:
ruby ./set_assume_role_cred.rb -a stg-example -r admin -u whoami -m 12345
```

## reference
- [AWS-SDK-Ruby: assume_role-instance_method](https://docs.aws.amazon.com/sdkforruby/api/Aws/STS/Client.html#assume_role-instance_method)
- [Ruby の OptionParser チートシー](https://qiita.com/sonots/items/1b44ed3a770ef790a63d)

## Todo
- [ ] auto append aws credentialfile