require "rspec/core/rake_task"

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |task|
  file_list = FileList["spec/**/*_spec.rb"]

  task.pattern = file_list
end
