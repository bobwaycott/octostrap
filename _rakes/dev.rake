starter_dir = DIRS.starter_dir
data_dir    = DIRS.data_dir
source_dir  = DIRS.source_dir
public_dir  = DIRS.public_dir

desc "OCTOSTRAP DEV ONLY: do not use; for internal use only; syncs starterpack files prior to git push"
task :prep do
  cp "./Rakefile", "#{starter_dir}/Rakefile.example"
  cp "./config.rb", "#{starter_dir}/config.rb.example"
end

desc "DESTRUCTIVE: returns Octostrap to default state"
task :reset do
  unless ask("DESTRUCTION AHEAD! Proceeding will delete your site. Are you sure?", ['y', 'n']) == 'n'
    rm_rf ["#{source_dir}", "#{public_dir}", "#{data_dir}", "config}"]
    cp "#{starter_dir}/Rakefile.example", "./Rakefile"
    cp "#{starter_dir}/config.rb.example", "./config.rb"
    puts "\nReset complete. Run `rake setup` again to start a fresh project."
  end
end
