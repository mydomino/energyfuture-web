# core
gulp  = require 'gulp'
gutil = require 'gulp-util'

# stream utilities
gif  = require 'gulp-if'
path = require 'path'

# plugins
htmlmin  = require 'gulp-minify-html'
react    = require 'gulp-react'
stylus   = require 'gulp-stylus'
concat   = require 'gulp-concat'
uglify   = require 'gulp-uglify'
csso     = require 'gulp-csso'
reload   = require 'gulp-livereload'
cache    = require 'gulp-cached'
jshint   = require 'gulp-jshint'
jsonlint = require 'gulp-jsonlint'
cmq      = require 'gulp-combine-media-queries'
plumber  = require 'gulp-plumber'
preprocess = require 'gulp-preprocess'
autoprefixer = require 'autoprefixer-stylus'
browserify = require 'gulp-browserify'
mochaPhantomJS = require 'gulp-mocha-phantomjs'

# misc
nib = require 'nib'
autowatch = require 'gulp-autowatch'

cssSupport = [
  'last 5 versions',
  '> 1%',
  'ie 8', 'ie 7',
  'Android', 'Android 4',
  'BlackBerry 10'
]

# paths
paths =
  vendor: './client/vendor/**/*'
  img: './client/img/**/*'
  fonts: './client/fonts/**/*'
  coffee: './client/**/*.coffee'
  stylus: './client/**/*.styl'
  css: './client/**/*.css'
  html: './client/**/*.html'

gutil.env.development = (process.env.NODE_ENV != "production")
gutil.env.production = (process.env.NODE_ENV == "production")

gulp.task 'server', ->
  reload()
  require('./start')

# javascript
gulp.task 'coffee', ->
  gulp.src('./client/start.coffee', { read: false })
    .pipe(browserify({ transform: ['coffeeify'], extensions: ['.coffee'] }))
    .pipe(concat('app.js'))
    .pipe(preprocess())
    .pipe(gif(gutil.env.production, uglify({ mangle: false })))
    .pipe(gulp.dest('./public'))
    .pipe(gif(gutil.env.development, reload()))

# styles
gulp.task 'stylus', ->
  gulp.src(paths.stylus)
    .pipe(stylus({
      use: [
        nib(),
        autoprefixer(cssSupport, {cascade: true})
      ]
    }))
    .pipe(concat('app.css'))
    .pipe(preprocess())
    .pipe(gif(gutil.env.production, csso()))
    .pipe(gulp.dest('./public/css'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task 'html', ->
  gulp.src(paths.html)
    .pipe(cache('html'))
    .pipe(preprocess())
    .pipe(gif(gutil.env.production, htmlmin()))
    .pipe(gulp.dest('./public'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task 'vendor', ->
  gulp.src(paths.vendor)
    .pipe(cache('vendor'))
    .pipe(gulp.dest('./public/vendor'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task 'img', ->
  gulp.src(paths.img)
    .pipe(cache('img'))
    .pipe(gulp.dest('./public/img'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task 'raw-css', ->
  gulp.src(paths.css)
    .pipe(preprocess())
    .pipe(cache('css'))
    .pipe(gulp.dest('./public'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task 'fonts', ->
  gulp.src(paths.fonts)
    .pipe(cache('fonts'))
    .pipe(gulp.dest('./public/fonts'))
    .pipe(gif(gutil.env.development, reload()))

gulp.task "browserify-tests", ->
  gulp.src('./client/test/runner.js', { read: false })
    .pipe(browserify({ transform: ['coffeeify'], extensions: ['.coffee'] }))
    .pipe(concat('tests.js'))
    .pipe(preprocess())
    .pipe(gulp.dest("./build"))

gulp.task "test", ["browserify-tests"], ->
  gulp.src("./client/test/runner.html")
    .pipe(mochaPhantomJS(
        mocha:
          globals: ["chai"]
          timeout: 6000
          ignoreLeaks: false
          ui: "bdd"
          reporter: "spec"))

gulp.task 'watch', ->
  autowatch gulp, paths

gulp.task 'css', ['raw-css', 'stylus']
gulp.task 'js', ['coffee']
gulp.task 'static', ['html', 'vendor', 'img', 'fonts']
gulp.task 'default', ['js', 'css', 'static', 'server', 'watch']
gulp.task 'deploy', ['js', 'css', 'static']
