require 'ostruct'
require 'sass-globbing'
require 'yaml'

DIRS = OpenStruct.new(YAML.load_file('config/dirs.yml'))

# Require any additional compass plugins here.
project_type = :stand_alone

# Publishing paths from config/deploy.yml
http_path = DIRS.http_path
http_images_path = DIRS.http_images_path
http_generated_images_path = DIRS.http_generated_images_path
http_fonts_path = DIRS.http_fonts_path
css_dir = DIRS.css_dir

# Local development paths from config/deploy.yml
sass_dir = DIRS.sass_dir
images_dir = DIRS.images_dir
fonts_dir = DIRS.fonts_dir

line_comments = false
output_style = :compressed
