#!/usr/bin/env ruby

# Source AWS Profile
@source_aws_profile = "default"

# AWS Accounts
# notice: "default" is not delete
@aws_accounts = {
    "default" => "123456789012",
    "section-01" => "123456789012",
    "production" => "210987654321",
}

# Roles
@role = {
    "admin" => "adminrole",
    "develop" => "developrole",
}