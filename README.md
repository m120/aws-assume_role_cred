# aws-assume_role_cred
Setting AWS AssumeRole Credential

## Install
```
$ git clone https://github.com/m120/aws-assume_role-cred
```

## Prepare
make `config.rb`
```
$ cp example_config.rb config.rb 
$ vi config.rb 
```

## Usage
```
$ ruby ./assume_role_cred.rb -a {AWS Acount} -r {Role} -u {username} -m {MFA TOKEN}
```

- Example:
  - Exec:
  ```
   $ ruby ./assume_role_cred.rb -a section-01 -r admin -u john.snow -m 12345
     [section-01-admin]
     aws_access_key_id = ASASDFGHJKLQWERTYUI3
     aws_secret_access_key = ASdfgHjkLQwwertYUI/zXCVB0NMASFgH2jklQwER
     role_arn = arn:aws:iam::123456789012:role/adminrole
     mfa_serial = arn:aws:iam::987654321098:mfa/john.snow
     region = ap-northeast-1
     source_profile = default
  ```

  - Copy result to ~/.aws/credential
  ```
  $ vi ~/.aws/credential
  ~ snip ~
    [section-01-admin]
     aws_access_key_id = ASASDFGHJKLQWERTYUI3
     aws_secret_access_key = ASdfgHjkLQwwertYUI/zXCVB0NMASFgH2jklQwER
     role_arn = arn:aws:iam::123456789012:role/adminrole
     mfa_serial = arn:aws:iam::987654321098:mfa/john.snow
     region = ap-northeast-1
     source_profile = default
  ```
  
  - Check:
  ```
  $ aws --prof section-01-admin s3 ls
  Enter MFA code for arn:aws:iam::987654321098:mfa/john.snow: {MFA Toke}
  2019-06-12 06:15:30 examplebuckets
  ```


- *Options:*
```
  $ ruby ./assume_role_cred.rb
  Usage: assume_role_cred [options]
      -a, --aws_acnt                   AWS account (Default: default) / AWS Account List: --list_aws_acnt
      -r, --role                       Role (Default: admin) / Role List: --list_role
      -u, --user value                 IAM Username (Require)
      -m, --mfa_token integer          MFA TokeCode (Require)
          --region value               AWS Region (Default: ap-northeast-1)
          --list_aws_acnt              List: AWS Account
          --list_role                  List: Role
```

#### Reference
  - [AWS-SDK-Ruby: assume_role-instance_method](https://docs.aws.amazon.com/sdkforruby/api/Aws/STS/Client.html#assume_role-instance_method)
  - [Ruby の OptionParser チートシート](https://qiita.com/sonots/items/1b44ed3a770ef790a63d)

## Todo
- [ ] auto append credentialfile