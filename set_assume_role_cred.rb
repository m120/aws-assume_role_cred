#!/usr/bin/env ruby

require './config'
require 'aws-sdk'
require 'optparse'
require 'pp'

## initial value 
option = {
    target_aws_acnt: 'default',
    aws_region: 'ap-northeast-1',
    target_role: 'admin'
}

# ARG ないときは help表示
ARGV << '-h' if ARGV.empty?

OptionParser.new do |opt|
    opt.on('-a',   '--aws_acnt', "AWS account (default: #{option[:target_aws_acnt]}) / AWS Account List: --list_aws_acnt") {|v|
        option[:target_aws_acnt] = v
    }

    opt.on('-r',   '--role', "Role (default: #{option[:target_role]}) / Role List: --list_role") {|v|
        option[:target_role] = v
    }

    opt.on('-u value',   '--user', 'IAM Username (Require)') {|v|
        option[:user_name] = v
    }

    opt.on('-m integer',   '--mfa_token', 'MFA TokeCode (Require)') {|v|
        option[:mfa_token] = v
    }

    opt.on('--region value', "AWS Region (default: #{option[:aws_region]})") {|v|
        option[:aws_region] = v
    }

    opt.on('--list_aws_acnt', "List: AWS Account") {|v|
        option[:aws_acnt_list] = v
    }

    opt.on('--list_role', "List: Role") {|v|
        option[:role_list] = v
    }

    opt.parse!(ARGV)
end

# List accounts
if option[:aws_acnt_list]
    pp @aws_accounts
    exit
end

# List roles
if option[:role_list]
    pp @role
    exit
end

target_aws_acnt = option[:target_aws_acnt]
target_role = option[:target_role]
aws_region = option[:aws_region]
user_name = option[:user_name]
@mfa_token = option[:mfa_token]

aws_acnt_id = @aws_accounts.fetch(target_aws_acnt)
role = @role.fetch(target_role)
@source_aws_acnt_id = @aws_accounts.fetch("#{@source_aws_profile}")

begin
    sts_client = Aws::STS::Client.new(region: "#{aws_region}", profile: "#{@source_aws_profile}")
    resp = sts_client.assume_role({
        role_arn: "arn:aws:iam::#{aws_acnt_id}:role/#{role}",
        role_session_name: "getsts",
        serial_number: "arn:aws:iam::#{@source_aws_acnt_id}:mfa/#{user_name}",
        token_code: "#{@mfa_token}",
    })
rescue => e
    puts e
    exit 1
end

puts "[#{target_aws_acnt}-#{target_role}]"
puts "aws_access_key_id = #{resp.credentials.access_key_id}"
puts "aws_secret_access_key = #{resp.credentials.secret_access_key}"
puts "role_arn = arn:aws:iam::#{aws_acnt_id}:role/#{role}"
puts "mfa_serial = arn:aws:iam::#{@source_aws_acnt_id}:mfa/#{user_name}"
puts "region = #{aws_region}"
puts "source_profile = #{@source_aws_profile}"
