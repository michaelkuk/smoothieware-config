gulp = require('gulp')
coffee = require('gulp-coffee')
browserify = require('browserify')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
gutil = require('gulp-util')
coffeeify = require('coffeeify')
sourcemaps = require('gulp-sourcemaps')
uglify = require('gulp-uglify')
istanbul = require('gulp-coffee-istanbul')
mocha = require('gulp-mocha')

# Expose to all tests
chai = require('chai')
chaiPromise = require('chai-as-promised')
global.expect = require('chai').expect
global.APP_ROOT = __dirname

gulp.task 'browserify', ()->
    opts =
        extensions: [
            '.js'
            '.coffee'
            '.json'
        ]
        entries: './src/bootstrap'
        transform:[coffeeify]
        debug: true

    b = browserify(opts)

    return b.bundle()
    .pipe(source('index.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init())
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('release/browser'))

gulp.task 'coffee', ()->
    return gulp.src('src/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', ()-> @emit('end')))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('release/node'))

gulp.task 'pre-test', ()->
    return gulp.src(['src/**/*.coffee', '!src/bootstrap.coffee'])
    .pipe(istanbul({includeUntested: true}).on('error', ()-> @emit('end')))
    .pipe(istanbul.hookRequire())

gulp.task 'test', ['pre-test'], ()->
    return gulp.src('tests/**/*.spec.coffee', {read: false})
    .pipe(mocha({reporter: 'spec'}).on('error', ()-> @emit('end')))
    .pipe(istanbul.writeReports())

gulp.task 'watch', ()->
    gulp.watch(['src/**/*.coffee'], ['coffee', 'browserify', 'test'])
    gulp.watch(['tests/**/*.spec.coffee'], ['test'])
    return

gulp.task 'build', ['coffee', 'browserify']

gulp.task 'default', ['test', 'build', 'watch']
