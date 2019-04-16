#!/usr/bin/env ruby

require 'aws-sdk'
require 'optparse'
require './config'

## initial value 
option = {
    target_aws_acnt: 'default',
    aws_region: 'ap-northeast-1',
    target_role: 'admin'
}

OptionParser.new do |opt|
    opt.on('-a value',   '--aws_acnt', "AWS Acount (require / default: #{option[:target_aws_acnt]})") {|v|
        option[:target_aws_acnt] = v
    }

    opt.on('-r value',   '--role', "Role (require / default: #{option[:target_role]})") {|v|
        option[:target_role] = v
    }

    opt.on('-u value',   '--user', 'IAM Username (require)') {|v|
        option[:user_name] = v
    }

    opt.on('-m integer',   '--mfa_token', 'MFA TokeCode (require)') {|v|
        option[:mfa_token] = v
    }

    opt.on('--region value', "AWS Region (default: #{option[:aws_region]})") {|v|
        option[:aws_region] = v
    }

    #opt.on('--aws_acnt_list boolean', "AWS Acount list") {|v|
    #    option[:aws_acnt_list] = v
    #}
    #
    #opt.on('--role_list boolean', "Role list") {|v|
    #    option[:role_list] = v
    #}

    opt.parse!(ARGV)
end

target_aws_acnt = option[:target_aws_acnt]
target_role = option[:target_role]
aws_region = option[:aws_region]
user_name = option[:user_name]
@mfa_token = option[:mfa_token]

aws_acnt_id = @aws_accounts.fetch(target_aws_acnt)
role = @role.fetch(target_role)
@source_aws_acnt_id = @aws_accounts.fetch("#{@source_aws_profile}")

sts_client = Aws::STS::Client.new(region: "#{aws_region}", profile: "#{@source_aws_profile}")
resp = sts_client.assume_role({
    role_arn: "arn:aws:iam::#{aws_acnt_id}:role/#{role}",
    role_session_name: "getsts",
    serial_number: "arn:aws:iam::#{@source_aws_acnt_id}:mfa/#{user_name}",
    token_code: "#{@mfa_token}",
})

puts "[#{target_aws_acnt}-#{target_role}]"
puts "aws_access_key_id = #{resp.credentials.access_key_id}"
puts "aws_secret_access_key = #{resp.credentials.secret_access_key}"
puts "role_arn = arn:aws:iam::#{aws_acnt_id}:role/#{role}"
puts "mfa_serial = arn:aws:iam::#{@source_aws_acnt_id}:mfa/#{user_name}"
puts "region = #{aws_region}"
puts "source_aws_profile = #{@source_aws_profile}"
