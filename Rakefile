require 'rubygems'
require 'bundler/setup'
require 'stringex'
require 'ostruct'
require 'yaml'

if File.exists?('config/dirs.yml')
  DIRS = OpenStruct.new(YAML.load_file('config/dirs.yml'))
else
  DIRS = OpenStruct.new(YAML.load_file('.starterpack/configs/dirs.yml.example'))
end

if File.exists?('config/dirs.yml')
  DEPLOY = OpenStruct.new(YAML.load_file('config/deploy.yml'))
else
  DEPLOY = OpenStruct.new(YAML.load_file('.starterpack/configs/deploy.yml.example'))
end

## -- Rsync Deploy config -- ##
# Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
ssh_user       = DEPLOY.ssh_user
ssh_port       = DEPLOY.ssh_port
document_root  = DEPLOY.document_root
rsync_delete   = DEPLOY.rsync_delete
rsync_args     = DEPLOY.rsync_args
deploy_default = DEPLOY.deploy_default

# This will be configured for you when you run config_deploy
deploy_branch  = DEPLOY.deploy_branch

## -- Directories -- ##
starter_dir     = DIRS.starter_dir
config_dir      = DIRS.config_dir
public_dir      = DIRS.public_dir
source_dir      = DIRS.source_dir
blog_index_dir  = DIRS.blog_index_dir
deploy_dir      = DIRS.deploy_dir
stash_dir       = DIRS.stash_dir
posts_dir       = DIRS.posts_dir
data_dir        = DIRS.data_dir
events_dir      = DIRS.events_dir
new_post_ext    = DIRS.new_post_ext
new_page_ext    = DIRS.new_page_ext
server_port     = DIRS.server_port

# Import all .rake files from rakes/
Dir.glob('_rakes/*.rake').each { |rakefile| import rakefile }

#########################
# Managing Octostrap
#########################

desc "Initial setup for Octostrap: copies source/ starting point; prompts for setting Github repo and Github Pages"
task :setup, :no_prompt do |t, args|
  if File.directory?(source_dir)
    abort("rake aborted!") if ask("Octostrap is already setup! Proceeding will overwrite existing files. Are you sure?", ['y', 'n']) == 'n'
  end
  # copy StarterPack into project folder
  puts "## Copying StarterPack into ./#{source_dir} ..."

  mkdir_p [source_dir, data_dir, config_dir, public_dir]
  cp_r "#{starter_dir}/source/.", source_dir
  cp "#{starter_dir}/configs/config.yml.example", "#{config_dir}/config.yml"
  cp "#{starter_dir}/configs/dirs.yml.example", "#{config_dir}/dirs.yml"
  cp "#{starter_dir}/configs/deploy.yml.example", "#{config_dir}/deploy.yml"
  begin
    symlink("#{config_dir}/config.yml", './_config.yml')
  rescue NotImplementedError
    cp "#{config_dir}/config.yml", "./_config.yml"
  end

  puts "## StarterPack copied. You can now `rake preview` and see your Octostrap site when setup is complete."

  if args.no_prompt
    puts "\nSkipping Events setup"
  else
    puts "\nOctostrap includes Event functionality that can now be included"
    puts "  Note: This is intended for campaign/political action sites that need to organize protests/events"
    if ask("\nWould you like to setup Octostrap Events?", ['y', 'n']) == 'y'
      puts "\nStarting Events setup ...\n"
      Rake::Task["setup_events"].invoke
    end
  end

  # maybe do takeover
  if args.no_prompt
    puts "\nSkipping Github setup"
  else
    repo_url = nil
    if ask("\nWould you like to proceed with Github repo setup?", ['y', 'n']) == 'y'
      puts "\nStarting Github setup ...\n"
      repo_url = get_repo_url if repo_url.nil?
      puts "\nAltering git config to use #{repo_url} as origin..."
      Rake::Task["takeover"].invoke(repo_url)
    else
      puts "Skipping Github repo setup"
    end
    if ask("\nWould you like to proceed with Github Pages setup?", ['y', 'n']) == 'y'
      puts "\nStarting Github Pages setup ...\n\n"
      repo_url = get_repo_url if repo_url.nil?
      Rake::Task["setup_github_pages"].invoke(repo_url)
    else
      puts "Skipping Github Pages setup"
    end
  end
end

desc "Take ownership of your Octostrap site: updates git settings to set Octostrap as upstream and your repo as origin"
task :takeover, :repo do |t, args|
  if args.repo
    repo_url = args.repo
  else
    puts "Enter the read/write url for your repository"
    puts "(For example, 'git@github.com:your_username/your_repo.git')"
    puts "           or 'https://github.com/your_username/your_repo.git')"
    repo_url = get_stdin("\nRepository url: ")
  end
  branch = (`git rev-parse --abbrev-ref HEAD`).strip
  unless (`git remote -v` =~ /origin.+?octostrap(?:\.git)?/).nil?
    # If octostrap is still the origin remote (from cloning) rename it to octostrap
    puts "\nRenaming remote origin to octostrap"
    system "git remote rename origin octostrap"
    # Add the correct origin remote for user's repository URL
    # and set new origin as master branch remote
    system "git remote add origin #{repo_url}"
    puts "Added remote #{repo_url} as origin"
    system "git config branch.#{branch}.remote origin"
    puts "Set origin as default remote"
    puts "\nI can go ahead and push this to origin if you'd like"
    puts "NOTE: You should only do this with a bare repository and an internet connection"
    if ask("\nShall I push to your repo?", ['y', 'n']) == 'y'
      puts "\nPushing to your repo ...\n\n"
      system "git push -u origin #{branch}"
    else
      puts "\nOkay, we'll skip that for now"
    end
  end
  puts "\n---\n## Takeover complete! ##"
end

desc "Set up _deploy folder and deploy branch for Github Pages deployment"
task :setup_github_pages, :repo do |t, args|
  if args.repo
    repo_url = args.repo
  else
    puts "Enter the read/write url for your repository"
    puts "(For example, 'git@github.com:your_username/your_username.github.io')"
    puts "           or 'https://github.com/your_username/your_username.github.io')"
    repo_url = get_stdin("\nRepository url: ")
  end
  branch = (repo_url.match(/\/[\w-]+\.github\.(?:io|com)/).nil?) ? 'gh-pages' : 'master'
  protocol = (repo_url.match(/(^git)@/).nil?) ? 'https' : 'git'
  if protocol == 'git'
    user = repo_url.match(/:([^\/]+)/)[1]
    project = (branch == 'gh-pages') ? repo_url.match(/\/([^\.]+)/)[1] : ''
  else
    user = repo_url.match(/github\.com\/([^\/]+)/)[1]
    project = (branch == 'gh-pages') ? repo_url.match(/\/\/github\.com\/\w+\/([^\.]+)/)[1] : ''
  end
  if !(`git remote -v` =~ /origin.+?octostrap(?:\.git)?/).nil?
    # If octopress is still the origin remote (from cloning) rename it to octopress
    system "git remote rename origin octostrap"
    if branch == 'master'
      # If this is a user/organization pages repository, add the correct origin remote
      # and checkout the source branch for committing changes to the blog source.
      system "\ngit remote add origin #{repo_url}"
      puts "Added remote #{repo_url} as origin"
      system "git config branch.master.remote origin"
      puts "Set origin as default remote"
      system "git branch -m master source"
      puts "Master branch renamed to 'source' for committing your blog source files"
    else
      unless !public_dir.match("#{project}").nil?
        system "rake set_root_dir[#{project}]"
      end
    end
  else
    unless !public_dir.match("#{project}").nil?
      system "rake set_root_dir[#{project}]"
    end
  end
  url = "http://#{user}.github.io"
  url += "/#{project}" unless project == ''
  jekyll_config = IO.read('config/config.yml')
  jekyll_config.sub!(/^url:.*$/, "url: #{url}")
  File.open('config/config.yml', 'w') do |f|
    f.write jekyll_config
  end

  # update config
  conf_file = 'config/deploy.yml'
  conf = IO.read(conf_file)
  conf.sub!(/deploy_branch:(\s*)(["'])[\w-]*["']/, "deploy_branch: \"#{branch}\"")
  conf.sub!(/deploy_default:(\s*)(["'])[\w-]*["']/, "deploy_default: \"push\"")
  File.open(conf_file, 'w') do |f|
    f.write conf
  end

  # setup deploy dir + branch
  rm_rf deploy_dir
  mkdir deploy_dir
  cd "#{deploy_dir}" do
    system "git init"
    system "echo 'My Octostrap Page is coming soon &hellip;' > index.html"
    system "git add ."
    system "git commit -m \"Octostrap init\""
    system "git branch -m gh-pages" unless branch == 'master'
    system "git remote add origin #{repo_url}"
  end
  puts "\n---\n## Success! Now you can deploy to #{url} with `rake gen_deploy` ##"
end

#######################
# Working with Jekyll #
#######################

desc "Generate jekyll site"
task :generate do
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)
  puts "## Generating Site with Jekyll"
  # system "compass compile --css-dir #{source_dir}/stylesheets"
  system "jekyll"
end

desc "Watch the site and regenerate when it changes"
task :watch do
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)
  puts "Starting to watch source with Jekyll and Compass."
  # system "compass compile --css-dir #{source_dir}/stylesheets" unless File.exist?("#{source_dir}/stylesheets/screen.css")
  jekyllPid = Process.spawn({"OCTOPRESS_ENV"=>"preview"}, "jekyll --auto")
  compassPid = Process.spawn("compass watch")

  trap("INT") {
    [jekyllPid, compassPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid].each { |pid| Process.wait(pid) }
end

desc "Preview the site in a web browser"
task :preview, :port do |t, args|
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)
  if args.port
    server_port = args.port
  end
  puts "Starting to watch source with Jekyll and Compass. Starting Rack on port #{server_port}"
  jekyllPid = Process.spawn({"OCTOPRESS_ENV"=>"preview"}, "jekyll --auto")
  compassPid = Process.spawn("compass watch")
  rackupPid = Process.spawn("rackup --port #{server_port}")

  trap("INT") {
    [jekyllPid, compassPid, rackupPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid, rackupPid].each { |pid| Process.wait(pid) }
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)

  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end

  mkdir_p "#{source_dir}/#{posts_dir}"
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "comments: true"
    post.puts "sharing: true"
    post.puts "categories: "
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{source_dir}/(filename)/index.#{new_page_ext}"
task :new_page, :filename do |t, args|
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)

  if args.filename
    filename = args.filename
  else
    filename = get_stdin("Enter a title for your page: ")
    filename = filename.to_url
  end

  page_dir = [source_dir]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= new_page_ext
    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    mkdir_p page_dir
    file = "#{page_dir}/#{filename}.#{extension}"
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: page"
      page.puts "title: \"#{title}\""
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      page.puts "sharing: true"
      page.puts "footer: true"
      page.puts "---"
    end
  else
    puts "Syntax error: #{args.filename} contains unsupported characters"
  end
end

# usage rake isolate[my-post]
desc "Move all other posts than the one currently being worked on to a temporary stash location (stash) so regenerating the site happens much more quickly."
task :isolate, :filename do |t, args|
  stash_dir = "#{source_dir}/#{stash_dir}"
  FileUtils.mkdir(stash_dir) unless File.exist?(stash_dir)
  Dir.glob("#{source_dir}/#{posts_dir}/*.*") do |post|
    FileUtils.mv post, stash_dir unless post.include?(args.filename)
  end
end

desc "Move all stashed posts back into the posts directory, ready for site generation."
task :integrate do
  FileUtils.mv Dir.glob("#{source_dir}/#{stash_dir}/*.*"), "#{source_dir}/#{posts_dir}/"
end

desc "Clean out caches: .pygments-cache, .gist-cache, .sass-cache"
task :clean do
  rm_rf [".pygments-cache/**", ".gist-cache/**", ".sass-cache/**", "source/stylesheets/screen.css"]
end

desc "Move sass to sass.old, install sass theme updates, replace sass/custom with sass.old/custom"
task :update_style, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("sass.old")
    puts "removed existing sass.old directory"
    rm_r "sass.old", :secure=>true
  end
  mv "sass", "sass.old"
  puts "## Moved styles into sass.old/"
  cp_r "#{themes_dir}/"+theme+"/sass/", "sass"
  cp_r "sass.old/custom/.", "sass/custom"
  puts "## Updated Sass ##"
end

desc "Move source to source.old, install source theme updates, replace source/_includes/navigation.html with source.old's navigation"
task :update_source, :theme do |t, args|
  theme = args.theme || 'classic'
  if File.directory?("#{source_dir}.old")
    puts "## Removed existing #{source_dir}.old directory"
    rm_r "#{source_dir}.old", :secure=>true
  end
  mkdir "#{source_dir}.old"
  cp_r "#{source_dir}/.", "#{source_dir}.old"
  puts "## Copied #{source_dir} into #{source_dir}.old/"
  cp_r "#{themes_dir}/"+theme+"/source/.", source_dir, :remove_destination=>true
  cp_r "#{source_dir}.old/_includes/custom/.", "#{source_dir}/_includes/custom/", :remove_destination=>true
  cp "#{source_dir}.old/favicon.png", source_dir
  mv "#{source_dir}/index.html", "#{blog_index_dir}", :force=>true if blog_index_dir != source_dir
  cp "#{source_dir}.old/index.html", source_dir if blog_index_dir != source_dir && File.exists?("#{source_dir}.old/index.html")
  puts "## Updated #{source_dir} ##"
end

##############
# Deploying  #
##############

desc "Default deploy task"
task :deploy do
  # Check if preview posts exist, which should not be published
  if File.exists?(".preview-mode")
    puts "## Found posts in preview mode, regenerating files ..."
    File.delete(".preview-mode")
    Rake::Task[:generate].execute
  end

  Rake::Task[:copydot].invoke(source_dir, public_dir)
  Rake::Task["#{deploy_default}"].execute
end

desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy] do
end

desc "copy dot files for deployment"
task :copydot, :source, :dest do |t, args|
  FileList["#{args.source}/**/.*"].exclude("**/.", "**/..", "**/.DS_Store", "**/._*").each do |file|
    cp_r file, file.gsub(/#{args.source}/, "#{args.dest}") unless File.directory?(file)
  end
end

desc "Deploy website via rsync"
task :rsync do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{ssh_port}' #{exclude} #{rsync_args} #{"--delete" unless rsync_delete == false} #{public_dir}/ #{ssh_user}:#{document_root}")
end

desc "deploy public directory to github pages"
multitask :push do
  puts "## Deploying branch to Github Pages "
  puts "## Pulling any updates from Github Pages "
  cd "#{deploy_dir}" do
    system "git pull"
  end
  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  Rake::Task[:copydot].invoke(public_dir, deploy_dir)
  puts "\n## Copying #{public_dir} to #{deploy_dir}"
  cp_r "#{public_dir}/.", deploy_dir
  cd "#{deploy_dir}" do
    # add .nojekyll file to prevent github jekyll processing
    File.open('./.nojekyll', 'w') { |file| file.write('') } unless File.exists?('./.nojekyll')
    system "git add -A"
    puts "\n## Commiting: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch}"
    puts "\n## Github Pages deploy complete"
  end
end

desc "Update configurations to support publishing to root or sub directory"
task :set_root_dir, :dir do |t, args|
  puts ">>> !! Please provide a directory, eg. rake config_dir[publishing/subdirectory]" unless args.dir
  if args.dir
    if args.dir == "/"
      dir = ""
    else
      dir = "/" + args.dir.sub(/(\/*)(.+)/, "\\2").sub(/\/$/, '');
    end
    # config files
    conf_file = 'config/config.yml'
    dirs_file = 'config/dirs.yml'
    # write changes
    dirs_config = IO.read(dirs_file)
    dirs_config.sub!(/public_dir(\s*):(\s*)(["'])[\w\-\/]*["']/, "public_dir\\1:\\2\\3public#{dir}\\3")
    dirs_config.sub!(/http_path(\s*):(\s*)(["'])[\w\-\/]*["']/, "http_path\\1:\\2\\3#{dir}/\\3")
    dirs_config.sub!(/http_images_path(\s*):(\s*)(["'])[\w\-\/]*["']/, "http_images_path\\1:\\2\\3#{dir}/images\\3")
    dirs_config.sub!(/http_fonts_path(\s*):(\s*)(["'])[\w\-\/]*["']/, "http_fonts_path\\1:\\2\\3#{dir}/fonts\\3")
    dirs_config.sub!(/css_dir(\s*):(\s*)(["'])[\w\-\/]*["']/, "css_dir\\1:\\2\\3public#{dir}/stylesheets\\3")
    File.open(dirs_file, 'w') do |f|
      f.write dirs_config
    end
    jekyll_config = IO.read(conf_file)
    jekyll_config.sub!(/^destination:.+$/, "destination: public#{dir}")
    jekyll_config.sub!(/^subscribe_rss:\s*\/.+$/, "subscribe_rss: #{dir}/atom.xml")
    jekyll_config.sub!(/^root:.*$/, "root: /#{dir.sub(/^\//, '')}")
    File.open(conf_file, 'w') do |f|
      f.write jekyll_config
    end
    rm_rf public_dir
    mkdir_p "#{public_dir}#{dir}"
    puts "## Site's root directory is now '/#{dir.sub(/^\//, '')}' ##"
  end
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

def get_repo_url
  puts "Enter the read/write url for your repository"
  puts "(For example, 'git@github.com:your_username/your_repo.git')"
  puts "           or 'https://github.com/your_username/your_repo.git')"
  get_stdin("\nRepository url: ")
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def ask(message, valid_options)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
