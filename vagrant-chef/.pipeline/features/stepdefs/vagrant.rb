require "rubygems"

Given(/^I am sshed into the environment$/) do
  run_cmd
end

When(/^I run "(.*?)"$/) do |cmd|
  self.output_lines = run_cmd.run(cmd)
end

Then(/^I should see "(.*?)"$/) do |value|
  output_lines.should include value
end