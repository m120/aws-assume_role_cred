#!/usr/bin/env ruby

# Source AWS Profile
@source_aws_profile = "default"

# AWS Accounts
@aws_accounts = {
    "section-01" => "123456789012",
    "production" => "210987654321",
}

# Roles
@role = {
    "admin" => "adminrole",
    "develop" => "developrole",
}