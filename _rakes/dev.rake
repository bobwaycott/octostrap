starter_dir = CONFIG.starter_dir
data_dir    = CONFIG.data_dir
source_dir  = CONFIG.source_dir
public_dir  = CONFIG.public_dir

desc "Octostrap ONLY: do not use; for internal use only; syncs starterpack files prior to git push"
task :prep do
  cp "./Rakefile", "#{starter_dir}/Rakefile.example"
  cp "./config.rb", "#{starter_dir}/config.rb.example"
  cp "./_config.yml", "#{starter_dir}/config.yml.example"
end

desc "DESTRUCTIVE: returns Octostrap to default state"
task :reset do
  unless ask("DESTRUCTION AHEAD! Proceeding will delete your site. Are you sure?", ['y', 'n']) == 'n'
    rm_rf ["#{source_dir}", "#{public_dir}", "#{data_dir}", "./_config.yml"]
    cp "#{starter_dir}/Rakefile.example", "./Rakefile"
    cp "#{starter_dir}/config.rb.example", "./config.rb"
    puts "\nReset complete. Run `rake setup` again to start a fresh project."
  end
end
