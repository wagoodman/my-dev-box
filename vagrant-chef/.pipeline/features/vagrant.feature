@ExcellaVagrantBox
Feature: Scripted install of Developer's Vagrant Configuration via CloudFormation
    As a continuous delivery engineer
    I would like Developer's VagrantBox to be installed and configured correctly
    so that the Developer's disposable environment will work consistently and as expected for developers

    Background:
        Given I am sshed into the environment
        
    Scenario: Is apache2 installed?
        When I run "apache2 -v"
        Then I should see "Apache/2.2.22 (Ubuntu)"
        When I run "service apache2 status"
        Then I should see "is running"

    Scenario: Is postgresql installed?
        When I run "sudo service postgresql status"
        Then I should see "9.3/main (port 5432): online"
        
    Scenario: Is the server listening on port 80?
        When I run "netstat -antu | grep 80"
        Then I should see ":80"

    Scenario: Is RVM and Ruby installed?
        When I run "ls /usr/local/rvm/rubies/ruby-2.1.2/bin/ruby"
        Then I should see "/usr/local/rvm/rubies/ruby-2.1.2/bin/ruby"

    Scenario: Is nmp installed?
        When I run "sudo npm -v"
        Then I should see "1.4.23"

    Scenario: Is nodejs installed?
        When I run "sudo nodejs -v"
        Then I should see "0.10.31"

    Scenario: Is bower installed?
        When I run "sudo bower -v"
        Then I should see "1.3.9"
    
    Scenario: Is rails installed?
        When I run "sudo rails -v"
        Then I should see "4.1.0"
    
    Scenario: Is Java installed?
        When I run "java -version"
        Then I should see "1.8.0_11"
        When I run "which java"
        Then I should see "/usr/bin/java"
        


    Scenario Outline: These tables should be present
        When I run "sudo psql -h localhost -d dev_db -U dev_db_user -c '<command>;'"
        Then I should see "<output>"
        
        Examples: commands that should execute
        | command                         | output  |
        | select 1                        | (1 row) |
