module.exports = function( grunt ) {

"use strict";

var
	// files
	coreFiles = [
		"jquery.ui.core_wev8.js",
		"jquery.ui.widget_wev8.js",
		"jquery.ui.mouse_wev8.js",
		"jquery.ui.draggable_wev8.js",
		"jquery.ui.droppable_wev8.js",
		"jquery.ui.resizable_wev8.js",
		"jquery.ui.selectable_wev8.js",
		"jquery.ui.sortable_wev8.js",
		"jquery.ui.effect_wev8.js"
	],

	uiFiles = coreFiles.map(function( file ) {
		return "ui/" + file;
	}).concat( expandFiles( "ui/*.js" ).filter(function( file ) {
		return coreFiles.indexOf( file.substring(3) ) === -1;
	})),

	allI18nFiles = expandFiles( "ui/i18n/*.js" ),

	cssFiles = [
		"core",
		"accordion",
		"autocomplete",
		"button",
		"datepicker",
		"dialog",
		"menu",
		"progressbar",
		"resizable",
		"selectable",
		"slider",
		"spinner",
		"tabs",
		"tooltip",
		"theme"
	].map(function( component ) {
		return "themes/base/jquery.ui." + component + ".css";
	}),

	// minified files
	minify = {
		options: {
			preserveComments: false
		},
		main: {
			options: {
				banner: createBanner( uiFiles )
			},
			files: {
				"dist/jquery-ui.min_wev8.js": "dist/jquery-ui_wev8.js"
			}
		},
		i18n: {
			options: {
				banner: createBanner( allI18nFiles )
			},
			files: {
				"dist/i18n/jquery-ui-i18n.min_wev8.js": "dist/i18n/jquery-ui-i18n_wev8.js"
			}
		}
	},

	minifyCSS = {
		options: {
			keepSpecialComments: 0
		},
		main: {
			options: {
				keepSpecialComments: "*"
			},
			src: "dist/jquery-ui_wev8.css",
			dest: "dist/jquery-ui.min_wev8.css"
		}
	},

	compareFiles = {
		all: [
			"dist/jquery-ui_wev8.js",
			"dist/jquery-ui.min_wev8.js"
		]
	};

function mapMinFile( file ) {
	return "dist/" + file.replace( /\.js$/, ".min_wev8.js" ).replace( /ui\//, "minified/" );
}

function expandFiles( files ) {
	return grunt.util._.pluck( grunt.file.expandMapping( files ), "src" ).map(function( values ) {
		return values[ 0 ];
	});
}

uiFiles.concat( allI18nFiles ).forEach(function( file ) {
	minify[ file ] = {
		options: {
			banner: createBanner()
		},
		files: {}
	};
	minify[ file ].files[ mapMinFile( file ) ] = file;
});

cssFiles.forEach(function( file ) {
	minifyCSS[ file ] = {
		options: {
			banner: createBanner()
		},
		src: file,
		dest: "dist/" + file.replace( /\.css$/, ".min_wev8.css" ).replace( /themes\/base\//, "themes/base/minified/" )
	};
});

uiFiles.forEach(function( file ) {
	// TODO this doesn't do anything until https://github.com/rwldrn/grunt-compare-size/issues/13
	compareFiles[ file ] = [ file,  mapMinFile( file ) ];
});

// grunt plugins
grunt.loadNpmTasks( "grunt-contrib-jshint" );
grunt.loadNpmTasks( "grunt-contrib-uglify" );
grunt.loadNpmTasks( "grunt-contrib-concat" );
grunt.loadNpmTasks( "grunt-contrib-qunit" );
grunt.loadNpmTasks( "grunt-contrib-csslint" );
grunt.loadNpmTasks( "grunt-contrib-cssmin" );
grunt.loadNpmTasks( "grunt-html" );
grunt.loadNpmTasks( "grunt-compare-size" );
grunt.loadNpmTasks( "grunt-git-authors" );
// local testswarm and build tasks
grunt.loadTasks( "build/tasks" );

function stripDirectory( file ) {
	return file.replace( /.+\/(.+?)>?$/, "$1" );
}

function createBanner( files ) {
	// strip folders
	var fileNames = files && files.map( stripDirectory );
	return "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " +
		"<%= grunt.template.today('isoDate') %>\n" +
		"<%= pkg.homepage ? '* ' + pkg.homepage + '\\n' : '' %>" +
		(files ? "* Includes: " + fileNames.join(", ") + "\n" : "")+
		"* Copyright <%= grunt.template.today('yyyy') %> <%= pkg.author.name %>;" +
		" Licensed <%= _.pluck(pkg.licenses, 'type').join(', ') %> */\n";
}

grunt.initConfig({
	pkg: grunt.file.readJSON("package.json"),
	files: {
		dist: "<%= pkg.name %>-<%= pkg.version %>",
		cdn: "<%= pkg.name %>-<%= pkg.version %>-cdn",
		themes: "<%= pkg.name %>-themes-<%= pkg.version %>"
	},
	compare_size: compareFiles,
	concat: {
		ui: {
			options: {
				banner: createBanner( uiFiles ),
				stripBanners: {
					block: true
				}
			},
			src: uiFiles,
			dest: "dist/jquery-ui_wev8.js"
		},
		i18n: {
			options: {
				banner: createBanner( allI18nFiles )
			},
			src: allI18nFiles,
			dest: "dist/i18n/jquery-ui-i18n_wev8.js"
		},
		css: {
			options: {
				banner: createBanner( cssFiles ),
				stripBanners: {
					block: true
				}
			},
			src: cssFiles,
			dest: "dist/jquery-ui_wev8.css"
		}
	},
	uglify: minify,
	cssmin: minifyCSS,
	htmllint: {
		// ignore files that contain invalid html, used only for ajax content testing
		all: grunt.file.expand( [ "demos/**/*.html", "tests/**/*.html" ] ).filter(function( file ) {
			return !/(?:ajax\/content\d\.html|tabs\/data\/test\.html|tests\/unit\/core\/core\.html)/.test( file );
		})
	},
	copy: {
		dist: {
			src: [
				"AUTHORS.txt",
				"jquery-*.js",
				"MIT-LICENSE.txt",
				"README.md",
				"Gruntfile_wev8.js",
				"package.json",
				"*.jquery.json",
				"ui/**/*",
				"ui/.jshintrc",
				"demos/**/*",
				"themes/**/*",
				"external/**/*",
				"tests/**/*"
			],
			renames: {
				"dist/jquery-ui_wev8.js": "ui/jquery-ui_wev8.js",
				"dist/jquery-ui.min_wev8.js": "ui/minified/jquery-ui.min_wev8.js",
				"dist/i18n/jquery-ui-i18n_wev8.js": "ui/i18n/jquery-ui-i18n_wev8.js",
				"dist/i18n/jquery-ui-i18n.min_wev8.js": "ui/minified/i18n/jquery-ui-i18n.min_wev8.js",
				"dist/jquery-ui_wev8.css": "themes/base/jquery-ui_wev8.css",
				"dist/jquery-ui.min_wev8.css": "themes/base/minified/jquery-ui.min_wev8.css"
			},
			dest: "dist/<%= files.dist %>"
		},
		dist_min: {
			src: "dist/minified/**/*",
			strip: /^dist/,
			dest: "dist/<%= files.dist %>/ui"
		},
		dist_css_min: {
			src: "dist/themes/base/minified/*.css",
			strip: /^dist/,
			dest: "dist/<%= files.dist %>"
		},
		dist_units_images: {
			src: "themes/base/images/*",
			strip: /^themes\/base\//,
			dest: "dist/"
		},
		dist_min_images: {
			src: "themes/base/images/*",
			strip: /^themes\/base\//,
			dest: "dist/<%= files.dist %>/themes/base/minified"
		},
		cdn: {
			src: [
				"AUTHORS.txt",
				"MIT-LICENSE.txt",
				"ui/*.js",
				"package.json"
			],
			renames: {
				"dist/jquery-ui_wev8.js": "jquery-ui_wev8.js",
				"dist/jquery-ui.min_wev8.js": "jquery-ui.min_wev8.js",
				"dist/i18n/jquery-ui-i18n_wev8.js": "i18n/jquery-ui-i18n_wev8.js",
				"dist/i18n/jquery-ui-i18n.min_wev8.js": "i18n/jquery-ui-i18n.min_wev8.js"
			},
			dest: "dist/<%= files.cdn %>"
		},
		cdn_i18n: {
			src: "ui/i18n/jquery.ui.datepicker-*.js",
			strip: "ui/",
			dest: "dist/<%= files.cdn %>"
		},
		cdn_i18n_min: {
			src: "dist/minified/i18n/jquery.ui.datepicker-*.js",
			strip: "dist/minified",
			dest: "dist/<%= files.cdn %>"
		},
		cdn_min: {
			src: "dist/minified/*.js",
			strip: /^dist\/minified/,
			dest: "dist/<%= files.cdn %>/ui"
		},
		cdn_themes: {
			src: "dist/<%= files.themes %>/themes/**/*",
			strip: "dist/<%= files.themes %>",
			dest: "dist/<%= files.cdn %>"
		},
		themes: {
			src: [
				"AUTHORS.txt",
				"MIT-LICENSE.txt",
				"package.json"
			],
			dest: "dist/<%= files.themes %>"
		}
	},
	zip: {
		dist: {
			src: "<%= files.dist %>",
			dest: "<%= files.dist %>.zip"
		},
		cdn: {
			src: "<%= files.cdn %>",
			dest: "<%= files.cdn %>.zip"
		},
		themes: {
			src: "<%= files.themes %>",
			dest: "<%= files.themes %>.zip"
		}
	},
	md5: {
		dist: {
			src: "dist/<%= files.dist %>",
			dest: "dist/<%= files.dist %>/MANIFEST"
		},
		cdn: {
			src: "dist/<%= files.cdn %>",
			dest: "dist/<%= files.cdn %>/MANIFEST"
		},
		themes: {
			src: "dist/<%= files.themes %>",
			dest: "dist/<%= files.themes %>/MANIFEST"
		}
	},
	qunit: {
		files: expandFiles( "tests/unit/**/*.html" ).filter(function( file ) {
			// disabling everything that doesn't (quite) work with PhantomJS for now
			// TODO except for all|index|test, try to include more as we go
			return !( /(all|index|test|dialog|dialog_deprecated|tabs|tooltip)\.html$/ ).test( file );
		})
	},
	jshint: {
		ui: {
			options: {
				jshintrc: "ui/.jshintrc"
			},
			files: {
				src: "ui/*.js"
			}
		},
		grunt: {
			options: {
				jshintrc: ".jshintrc"
			},
			files: {
				src: [ "Gruntfile_wev8.js", "build/**/*.js" ]
			}
		},
		tests: {
			options: {
				jshintrc: "tests/.jshintrc"
			},
			files: {
				src: "tests/unit/**/*.js"
			}
		}
	},
	csslint: {
		base_theme: {
			src: "themes/base/*.css",
			options: {
				"adjoining-classes": false,
				"box-model": false,
				"compatible-vendor-prefixes": false,
				"duplicate-background-images": false,
				"import": false,
				"important": false,
				"outline-none": false,
				"overqualified-elements": false,
				"text-indent": false
			}
		}
	}
});

grunt.registerTask( "default", [ "lint", "test" ] );
grunt.registerTask( "lint", [ "jshint", "csslint", "htmllint" ] );
grunt.registerTask( "test", [ "qunit" ] );
grunt.registerTask( "sizer", [ "concat:ui", "uglify:main", "compare_size:all" ] );
grunt.registerTask( "sizer_all", [ "concat:ui", "uglify", "compare_size" ] );
grunt.registerTask( "build", [ "concat", "uglify", "cssmin", "copy:dist_units_images" ] );
grunt.registerTask( "release", "clean build copy:dist copy:dist_min copy:dist_min_images copy:dist_css_min md5:dist zip:dist".split( " " ) );
grunt.registerTask( "release_themes", "release generate_themes copy:themes md5:themes zip:themes".split( " " ) );
grunt.registerTask( "release_cdn", "release_themes copy:cdn copy:cdn_min copy:cdn_i18n copy:cdn_i18n_min copy:cdn_themes md5:cdn zip:cdn".split( " " ) );

};
