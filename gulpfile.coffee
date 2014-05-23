# Versions.
bower = require './bower.json'
pkg = require './package.json'

# Initialize the gulp.
gulp = require 'gulp'

# Clean up.
clean = require 'gulp-clean'

# Coffee.
coffee = require 'gulp-coffee'

# Less.
less = require 'gulp-less'

# Nodemon.
nodemon = require 'gulp-nodemon'

# Utilities.
gutil = require 'gulp-util'
rename = require 'gulp-rename'

# Dist clean up task.
gulp.task 'distclean', ['clean'], ->
	gulp.src ['node_modules', 'gulpfile.js'], read: false
		.pipe clean()

# Clean up task.
gulp.task 'clean', ->
	gulp.src ['dist'], read: false
		.pipe clean()

# CoffeeScript.
gulp.task 'coffee', ->
	gulp.src 'src/**/*.coffee'
		.pipe coffee(bare: true).on 'error', gutil.log
		.pipe gulp.dest 'dist'

# Less.
gulp.task 'less', ->
	gulp.src 'src/less/bigreg.less'
		.pipe rename 'bigreg.min.less'
		.pipe less 'compress': true
		.pipe gulp.dest 'dist/web/static/' + pkg.name + '-' + pkg.version + '/css'

# Nodemon.
gulp.task 'nodemon', ['build'], ->
	nodemon
		script: 'dist/server/app.js'
		ext: 'js'
		watch: ['dist/']
	.on 'restart', ->
		console.log 'server restart'

# Copy files.
gulp.task 'copy', ->
	# jQuery.
	gulp.src 'vendor/jquery/dist/**'
		.pipe gulp.dest 'dist/web/static/jquery-' + bower.dependencies.jquery + '/js'

	# Bootstrap.
	gulp.src 'vendor/bootstrap/dist/**'
		.pipe gulp.dest 'dist/web/static/bootstrap-' + bower.dependencies.bootstrap

	# D3.
	gulp.src 'vendor/d3/d3*.js'
		.pipe gulp.dest 'dist/web/static/d3-' + bower.dependencies.d3 + '/js'

	# Underscore.
	gulp.src 'vendor/underscore/*.js'
		.pipe gulp.dest 'dist/web/static/underscore-' + bower.dependencies.underscore + '/js'

	# Moment.js
	gulp.src ['vendor/momentjs/*.js', 'vendor/momentjs/min/*.js']
		.pipe gulp.dest 'dist/web/static/momentjs-' + bower.dependencies.momentjs + '/js'

	# Data.
	gulp.src 'src/data/**'
		.pipe gulp.dest 'dist/web/data'

	# Home page.
	gulp.src 'src/web/index.html'
		.pipe gulp.dest 'dist/web'

# Watch for changes
gulp.task 'watch', ['build'], ->
	# Watch for CoffeeScript files.
	gulp.watch 'src/**/*', ['coffee']

	# Watch for static files.
	gulp.watch ['vendor/**', 'src/web/**'], ['copy']

# Build task.
gulp.task 'build', ->
	gulp.start 'coffee', 'less', 'copy'

# Default task.
gulp.task 'default', ->
	gulp.start 'watch', 'nodemon'