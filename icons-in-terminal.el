;;; icons-in-terminal.el --- Nerd icons library -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Vincent Zhang <seagle0128@gmail.com>

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; Created: 2019/04/06
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.4"))
;; URL:
;; Keywords: convenience

;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:

;; This package is inspired by https://github.com/domtronn/all-the-icons.el.
;; is a utility for using and formatting various Icon
;; fonts within Emacs.  Icon Fonts allow you to propertize and format
;; icons the same way you would normal text.  This enables things such
;; as better scaling of and anti aliasing of the icons.

;; See README.md for more information.

;;; Change Log:

;;; Code:

(require 'cl-lib)
(require 'icons-in-terminal-data)
(require 'icons-in-terminal-faces)

;;; Custom Variables

(defgroup icons-in-terminal nil
  "Manage how Nerd Icons formats icons."
  :prefix "icons-in-terminal-"
  :group 'appearance
  :group 'convenience)

(defcustom icons-in-terminal-color-icons t
  "Whether or not to include a foreground colour when formatting the icon."
  :group 'icons-in-terminal
  :type 'boolean)

(defcustom icons-in-terminal-scale-factor 1.2
  "The base Scale Factor for the `height' face property of an icon."
  :group 'icons-in-terminal
  :type 'number)

(defcustom icons-in-terminal-default-adjust -0.2
  "The default adjustment to be made to the `raise' display property of an icon."
  :group 'icons-in-terminal
  :type 'number)

(defvar icons-in-terminal-icon-spec
  '(;; Meta
    ("\\.tags"          icons-in-terminal-octicon "tag"                     :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue)
    ("^TAGS$"           icons-in-terminal-octicon "tag"                     :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue)
    ("\\.log"           icons-in-terminal-octicon "bug"                     :height 1.0 :v-adjust 0.0 :face icons-in-terminal-maroon)

    ;;
    ("\\.key$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-lblue)
    ("\\.pem$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-orange)
    ("\\.p12$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-dorange)
    ("\\.crt$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-lblue)
    ("\\.pub$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-blue)
    ("\\.gpg$"          icons-in-terminal-octicon "key"                     :v-adjust 0.0 :face icons-in-terminal-lblue)

    ("^TODO$"           icons-in-terminal-octicon "checklist"               :v-adjust 0.0 :face icons-in-terminal-lyellow)
    ("^LICENSE$"        icons-in-terminal-octicon "book"                    :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue)
    ("^readme"          icons-in-terminal-octicon "book"                    :height 1.0 :v-adjust 0.0 :face icons-in-terminal-lcyan)

    ("\\.fish"          icons-in-terminal-fileicon "terminal"               :face icons-in-terminal-lpink)
    ("\\.zsh"           icons-in-terminal-fileicon "terminal"               :face icons-in-terminal-lcyan)
    ("\\.sh"            icons-in-terminal-fileicon "terminal"               :face icons-in-terminal-purple)

    ;; Config
    ("\\.node"          icons-in-terminal-fileicon "nodejs"                 :height 1.0  :face icons-in-terminal-green)
    ("\\.babelrc$"      icons-in-terminal-fileicon "babel"                  :face icons-in-terminal-yellow)
    ("\\.bashrc$"       icons-in-terminal-fileicon "script"                 :height 0.9  :face icons-in-terminal-dpink)
    ("\\.bowerrc$"      icons-in-terminal-fileicon "bower"                  :height 1.0 :v-adjust 0.0 :face icons-in-terminal-silver)
    ("^bower.json$"     icons-in-terminal-fileicon "bower"                  :height 1.0 :v-adjust 0.0 :face icons-in-terminal-lorange)
    ("\\.ini$"          icons-in-terminal-octicon "settings"                :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.eslintignore"  icons-in-terminal-fileicon "eslint"                 :height 0.9  :face icons-in-terminal-purple)
    ("\\.eslint"        icons-in-terminal-fileicon "eslint"                 :height 0.9  :face icons-in-terminal-lpurple)
    ("\\.git"           icons-in-terminal-fileicon "git"                    :height 1.0 :face icons-in-terminal-lred)
    ("nginx"            icons-in-terminal-fileicon "nginx"                  :height 0.9  :face icons-in-terminal-dgreen)
    ("apache"           icons-in-terminal-fileicon "apache"                 :height 0.9  :face icons-in-terminal-dgreen)
    ("^Makefile$"       icons-in-terminal-fileicon "gnu"                    :face icons-in-terminal-dorange)
    ("\\.mk$"           icons-in-terminal-fileicon "gnu"                    :face icons-in-terminal-dorange)

    ("\\.dockerignore$" icons-in-terminal-fileicon "dockerfile"             :height 1.2  :face icons-in-terminal-dblue)
    ("^\\.?Dockerfile"  icons-in-terminal-fileicon "dockerfile"             :face icons-in-terminal-blue)
    ("^Brewfile$"       icons-in-terminal-faicon "beer"                     :face icons-in-terminal-lsilver)
    ("\\.npmignore"     icons-in-terminal-fileicon "npm"                    :face icons-in-terminal-dred)
    ("^package.json$"   icons-in-terminal-fileicon "npm"                    :face icons-in-terminal-red)
    ("^package.lock.json$" icons-in-terminal-fileicon "npm"                 :face icons-in-terminal-dred)
    ("^yarn\.lock"      icons-in-terminal-fileicon "yarn"                   :face icons-in-terminal-blue-alt)

    ("\.xml$"           icons-in-terminal-faicon "file-code-o"              :height 0.95 :face icons-in-terminal-lorange)

    ;; ;; AWS
    ("^stack.*.json$"   icons-in-terminal-fileicon "aws"                    :face icons-in-terminal-orange)


    ("^serverless\\.yml$" icons-in-terminal-faicon "bolt"                   :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.[jc]son$"      icons-in-terminal-octicon "settings"                :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.ya?ml$"        icons-in-terminal-octicon "settings"                :v-adjust 0.0 :face icons-in-terminal-dyellow)

    ("\\.pkg$"          icons-in-terminal-octicon "package"                 :v-adjust 0.0 :face icons-in-terminal-dsilver)
    ("\\.rpm$"          icons-in-terminal-octicon "package"                 :v-adjust 0.0 :face icons-in-terminal-dsilver)

    ("\\.elc$"          icons-in-terminal-octicon "file-binary"             :v-adjust 0.0 :face icons-in-terminal-dsilver)

    ("\\.gz$"           icons-in-terminal-octicon "file-binary"             :v-adjust 0.0 :face icons-in-terminal-lmaroon)
    ("\\.zip$"          icons-in-terminal-octicon "file-zip"                :v-adjust 0.0 :face icons-in-terminal-lmaroon)
    ("\\.7z$"           icons-in-terminal-octicon "file-zip"                :v-adjust 0.0 :face icons-in-terminal-lmaroon)

    ("\\.dat$"          icons-in-terminal-faicon "bar-chart"                :face icons-in-terminal-cyan :height 0.9)
    ;; lock files
    ("~$"               icons-in-terminal-octicon "lock"                    :v-adjust 0.0 :face icons-in-terminal-maroon)

    ("\\.dmg$"          icons-in-terminal-octicon "tools"                   :v-adjust 0.0 :face icons-in-terminal-lsilver)
    ("\\.dll$"          icons-in-terminal-faicon "cogs"                     :face icons-in-terminal-silver)
    ("\\.DS_STORE$"     icons-in-terminal-faicon "cogs"                     :face icons-in-terminal-silver)

    ;; Source Codes
    ("\\.scpt$"         icons-in-terminal-fileicon "apple"                  :face icons-in-terminal-pink)
    ("\\.aup$"          icons-in-terminal-fileicon "audacity"               :face icons-in-terminal-yellow)

    ("\\.elm"           icons-in-terminal-fileicon "elm"                    :face icons-in-terminal-blue)

    ("\\.erl$"          icons-in-terminal-fileicon "erlang"                 :face icons-in-terminal-red :v-adjust -0.1 :height 0.9)
    ("\\.hrl$"          icons-in-terminal-fileicon "erlang"                 :face icons-in-terminal-dred :v-adjust -0.1 :height 0.9)

    ("\\.eex$"          icons-in-terminal-fileicon "elixir"                 :face icons-in-terminal-lorange :v-adjust -0.1 :height 0.9)
    ("\\.ex$"           icons-in-terminal-fileicon "elixir"                 :face icons-in-terminal-lpurple :v-adjust -0.1 :height 0.9)
    ("\\.exs$"          icons-in-terminal-fileicon "elixir"                 :face icons-in-terminal-lred :v-adjust -0.1 :height 0.9)
    ("^mix.lock$"       icons-in-terminal-fileicon "elixir"                 :face icons-in-terminal-lyellow :v-adjust -0.1 :height 0.9)

    ("\\.java$"         icons-in-terminal-fileicon "java"                   :height 1.0  :face icons-in-terminal-purple)

    ("\\.go$"           icons-in-terminal-fileicon "go"                     :height 1.0  :face icons-in-terminal-blue)

    ("\\.mp3$"          icons-in-terminal-faicon "volume-up"                :face icons-in-terminal-dred)
    ("\\.wav$"          icons-in-terminal-faicon "volume-up"                :face icons-in-terminal-dred)
    ("\\.m4a$"          icons-in-terminal-faicon "volume-up"                :face icons-in-terminal-dred)

    ("\\.jl$"           icons-in-terminal-fileicon "julia"                  :v-adjust 0.0 :face icons-in-terminal-purple)
    ("\\.matlab$"       icons-in-terminal-fileicon "matlab"                 :face icons-in-terminal-orange)

    ("\\.nix$"          icons-in-terminal-fileicon "nix"                    :face icons-in-terminal-blue)

    ("\\.p[ml]$"        icons-in-terminal-fileicon "perl"                   :face icons-in-terminal-lorange)
    ("\\.pl6$"          icons-in-terminal-fileicon "perl6"                  :face icons-in-terminal-cyan)
    ("\\.pod$"          icons-in-terminal-fileicon "perldocs"               :height 1.2  :face icons-in-terminal-lgreen)

    ("\\.php$"          icons-in-terminal-fileicon "php"                    :face icons-in-terminal-lsilver)
    ("\\.pony$"         icons-in-terminal-fileicon "pony"                   :face icons-in-terminal-maroon)
    ("\\.prol?o?g?$"    icons-in-terminal-fileicon "prolog"                 :height 1.1  :face icons-in-terminal-lmaroon)
    ("\\.py$"           icons-in-terminal-fileicon "python"                 :height 1.0  :face icons-in-terminal-dblue)

    ("\\.rkt$"          icons-in-terminal-fileicon "racket"                 :height 1.2 :face icons-in-terminal-red)
    ("\\.gem$"          icons-in-terminal-fileicon "ruby-alt"               :face icons-in-terminal-red)
    ("_?test\\.rb$"        icons-in-terminal-fileicon "test-ruby"           :height 1.0 :v-adjust 0.0 :face icons-in-terminal-red)
    ("_?test_helper\\.rb$" icons-in-terminal-fileicon "test-ruby"           :height 1.0 :v-adjust 0.0 :face icons-in-terminal-dred)
    ("\\.rb$"           icons-in-terminal-fileicon "ruby"                   :v-adjust 0.0 :face icons-in-terminal-lred)
    ("\\.rs$"           icons-in-terminal-fileicon "rust"                   :height 1.2  :face icons-in-terminal-maroon)
    ("\\.rlib$"         icons-in-terminal-fileicon "rust"                   :height 1.2  :face icons-in-terminal-dmaroon)
    ("\\.r[ds]?x?$"     icons-in-terminal-fileicon "R"                      :face icons-in-terminal-lblue)

    ("\\.sbt$"          icons-in-terminal-fileicon   "sbt"                  :face icons-in-terminal-red)
    ("\\.scala$"        icons-in-terminal-fileicon "scala"                  :face icons-in-terminal-red)
    ("\\.scm$"          icons-in-terminal-fileicon   "scheme"               :height 1.2 :face icons-in-terminal-red)
    ("\\.swift$"        icons-in-terminal-fileicon "swift"                  :height 1.0 :v-adjust -0.1 :face icons-in-terminal-green)

    ("-?spec\\.ts$"     icons-in-terminal-fileicon "test-typescript"        :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue)
    ("-?test\\.ts$"     icons-in-terminal-fileicon "test-typescript"        :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue)
    ("-?spec\\.js$"     icons-in-terminal-fileicon "test-js"                :height 1.0 :v-adjust 0.0 :face icons-in-terminal-lpurple)
    ("-?test\\.js$"     icons-in-terminal-fileicon "test-js"                :height 1.0 :v-adjust 0.0 :face icons-in-terminal-lpurple)
    ("-?spec\\.jsx$"    icons-in-terminal-fileicon "test-react"             :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue-alt)
    ("-?test\\.jsx$"    icons-in-terminal-fileicon "test-react"             :height 1.0 :v-adjust 0.0 :face icons-in-terminal-blue-alt)

    ("-?spec\\."        icons-in-terminal-fileicon "test-generic"           :height 1.0 :v-adjust 0.0 :face icons-in-terminal-dgreen)
    ("-?test\\."        icons-in-terminal-fileicon "test-generic"           :height 1.0 :v-adjust 0.0 :face icons-in-terminal-dgreen)

    ("\\.tf\\(vars\\|state\\)?$" icons-in-terminal-fileicon "terraform"     :height 1.0 :face icons-in-terminal-purple-alt)

    ;; There seems to be a a bug with this font icon which does not
    ;; let you propertise it without it reverting to being a lower
    ;; case phi
    ("\\.c$"            icons-in-terminal-fileicon "c-line"                 :face icons-in-terminal-blue)
    ("\\.h$"            icons-in-terminal-fileicon "c-line"                 :face icons-in-terminal-purple)
    ("\\.m$"            icons-in-terminal-fileicon "apple"                  :v-adjust 0.0 :height 1.0)
    ("\\.mm$"           icons-in-terminal-fileicon "apple"                  :v-adjust 0.0 :height 1.0)

    ("\\.c\\(c\\|pp\\|xx\\)$"   icons-in-terminal-fileicon "cplusplus-line" :v-adjust -0.2 :face icons-in-terminal-blue)
    ("\\.h\\(h\\|pp\\|xx\\)$"   icons-in-terminal-fileicon "cplusplus-line" :v-adjust -0.2 :face icons-in-terminal-purple)

    ("\\.csx?$"         icons-in-terminal-fileicon "csharp-line"            :face icons-in-terminal-dblue)

    ("\\.cljc?$"        icons-in-terminal-fileicon "clojure-line"           :height 1.0 :face icons-in-terminal-blue :v-adjust 0.0)
    ("\\.cljs$"         icons-in-terminal-fileicon "cljs"                   :height 1.0 :face icons-in-terminal-dblue :v-adjust 0.0)

    ("\\.coffee$"       icons-in-terminal-fileicon "coffeescript"           :height 1.0  :face icons-in-terminal-maroon)
    ("\\.iced$"         icons-in-terminal-fileicon "coffeescript"           :height 1.0  :face icons-in-terminal-lmaroon)

    ;; Git
    ("^MERGE_"          icons-in-terminal-octicon "git-merge"               :v-adjust 0.0 :face icons-in-terminal-red)
    ("^COMMIT_EDITMSG"  icons-in-terminal-octicon "git-commit"              :v-adjust 0.0 :face icons-in-terminal-red)

    ;; Lisps
    ("\\.cl$"           icons-in-terminal-fileicon "clisp"                  :face icons-in-terminal-lorange)
    ("\\.l\\(isp\\)?$"  icons-in-terminal-fileicon "lisp"                   :face icons-in-terminal-orange)
    ("\\.el$"           icons-in-terminal-fileicon "elisp"                  :height 1.0 :v-adjust -0.2 :face icons-in-terminal-purple)

    ;; Stylesheeting
    ("\\.css$"          icons-in-terminal-fileicon "css3"                   :face icons-in-terminal-yellow)
    ("\\.scss$"         icons-in-terminal-fileicon "sass"                   :face icons-in-terminal-pink)
    ("\\.sass$"         icons-in-terminal-fileicon "sass"                   :face icons-in-terminal-dpink)
    ("\\.less$"         icons-in-terminal-fileicon "less"                   :height 0.8  :face icons-in-terminal-dyellow)
    ("\\.postcss$"      icons-in-terminal-fileicon "postcss"                :face icons-in-terminal-dred)
    ("\\.sss$"          icons-in-terminal-fileicon "postcss"                :face icons-in-terminal-dred)
    ("\\.styl$"         icons-in-terminal-fileicon "stylus"                 :face icons-in-terminal-lgreen)
    ("stylelint"        icons-in-terminal-fileicon "stylelint"              :face icons-in-terminal-lyellow)
    ("\\.csv$"          icons-in-terminal-octicon "graph"                   :v-adjust 0.0 :face icons-in-terminal-dblue)

    ("\\.hs$"           icons-in-terminal-fileicon "haskell"                :height 1.0  :face icons-in-terminal-red)

    ;; Web modes
    ("\\.inky-haml$"    icons-in-terminal-fileicon "haml"                   :face icons-in-terminal-lyellow)
    ("\\.haml$"         icons-in-terminal-fileicon "haml"                   :face icons-in-terminal-lyellow)
    ("\\.html?$"        icons-in-terminal-fileicon "html5"                  :face icons-in-terminal-orange)
    ("\\.inky-erb?$"    icons-in-terminal-fileicon "html5"                  :face icons-in-terminal-lred)
    ("\\.erb$"          icons-in-terminal-fileicon "html5"                  :face icons-in-terminal-lred)
    ("\\.hbs$"          icons-in-terminal-fileicon "moustache"              :face icons-in-terminal-green)
    ("\\.inky-slim$"    icons-in-terminal-octicon "dashboard"               :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.slim$"         icons-in-terminal-octicon "dashboard"               :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.jade$"         icons-in-terminal-fileicon "jade"                   :face icons-in-terminal-red)
    ("\\.pug$"          icons-in-terminal-fileicon "pug-alt"                :face icons-in-terminal-red)

    ;; JavaScript
    ("^gulpfile"        icons-in-terminal-fileicon "gulp"                   :height 1.0  :face icons-in-terminal-lred)
    ("^gruntfile"       icons-in-terminal-fileicon "grunt"                  :height 1.0 :v-adjust -0.1 :face icons-in-terminal-lyellow)
    ("^webpack"         icons-in-terminal-fileicon "webpack"                :face icons-in-terminal-lblue)

    ("\\.d3\\.?js"      icons-in-terminal-fileicon "d3"                     :height 0.8  :face icons-in-terminal-lgreen)

    ("\\.re$"            icons-in-terminal-fileicon "reason"                :height 1.0  :face icons-in-terminal-red-alt)
    ("\\.rei$"           icons-in-terminal-fileicon "reason"                :height 1.0  :face icons-in-terminal-dred)
    ("\\.ml$"            icons-in-terminal-fileicon "ocaml"                 :height 1.0  :face icons-in-terminal-lpink)
    ("\\.mli$"           icons-in-terminal-fileicon "ocaml"                 :height 1.0  :face icons-in-terminal-dpink)

    ("\\.react"         icons-in-terminal-fileicon "react"                  :height 1.1  :face icons-in-terminal-lblue)
    ("\\.d\\.ts$"       icons-in-terminal-fileicon "typescript"             :height 1.0 :v-adjust -0.1 :face icons-in-terminal-cyan-alt)
    ("\\.ts$"           icons-in-terminal-fileicon "typescript"             :height 1.0 :v-adjust -0.1 :face icons-in-terminal-blue-alt)
    ("\\.js$"           icons-in-terminal-fileicon "javascript"             :height 1.0 :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.es[0-9]$"      icons-in-terminal-fileicon "javascript"             :height 1.0 :v-adjust 0.0 :face icons-in-terminal-yellow)
    ("\\.jsx$"          icons-in-terminal-fileicon "jsx-2"                  :height 1.0 :v-adjust -0.1 :face icons-in-terminal-cyan-alt)
    ("\\.njs$"          icons-in-terminal-fileicon "nodejs"                 :height 1.2  :face icons-in-terminal-lgreen)
    ("\\.vue$"          icons-in-terminal-fileicon "vue"                    :face icons-in-terminal-lgreen)

    ;; File Types
    ("\\.ico$"          icons-in-terminal-octicon "file-media"              :v-adjust 0.0 :face icons-in-terminal-blue)
    ("\\.png$"          icons-in-terminal-octicon "file-media"              :v-adjust 0.0 :face icons-in-terminal-orange)
    ("\\.gif$"          icons-in-terminal-octicon "file-media"              :v-adjust 0.0 :face icons-in-terminal-green)
    ("\\.jpe?g$"        icons-in-terminal-octicon "file-media"              :v-adjust 0.0 :face icons-in-terminal-dblue)
    ("\\.svg$"          icons-in-terminal-fileicon "svg"                    :height 0.9  :face icons-in-terminal-lgreen)

    ;; Video
    ("\\.mov"           icons-in-terminal-faicon "film"                     :face icons-in-terminal-blue)
    ("\\.mp4"           icons-in-terminal-faicon "film"                     :face icons-in-terminal-blue)
    ("\\.ogv"           icons-in-terminal-faicon "film"                     :face icons-in-terminal-dblue)

    ;; Fonts
    ("\\.ttf$"          icons-in-terminal-fileicon "font"                   :v-adjust 0.0 :face icons-in-terminal-dcyan)
    ("\\.woff2?$"       icons-in-terminal-fileicon "font"                   :v-adjust 0.0 :face icons-in-terminal-cyan)

    ;; Doc
    ("\\.pdf"           icons-in-terminal-octicon "file-pdf"                :v-adjust 0.0 :face icons-in-terminal-dred)
    ("\\.te?xt"         icons-in-terminal-octicon "file-text"               :v-adjust 0.0 :face icons-in-terminal-cyan)
    ("\\.doc[xm]?$"     icons-in-terminal-fileicon "word"                   :face icons-in-terminal-blue)
    ("\\.texi?$"        icons-in-terminal-fileicon "tex"                    :face icons-in-terminal-lred)
    ("\\.md$"           icons-in-terminal-octicon "markdown"                :v-adjust 0.0 :face icons-in-terminal-lblue)
    ("\\.bib$"          icons-in-terminal-fileicon "bib"                    :face icons-in-terminal-maroon)
    ("\\.org$"          icons-in-terminal-fileicon "org"                    :face icons-in-terminal-lgreen)

    ("\\.pp[st]$"       icons-in-terminal-fileicon "powerpoint"             :face icons-in-terminal-orange)
    ("\\.pp[st]x$"      icons-in-terminal-fileicon "powerpoint"             :face icons-in-terminal-red)
    ("\\.knt$"          icons-in-terminal-fileicon "powerpoint"             :face icons-in-terminal-cyan)

    ("bookmark"         icons-in-terminal-octicon "bookmark"                :height 1.1 :v-adjust 0.0 :face icons-in-terminal-lpink)
    ("\\.cache$"        icons-in-terminal-octicon "database"                :height 1.0 :v-adjust 0.0 :face icons-in-terminal-green)

    ("^\\*scratch\\*$"  icons-in-terminal-faicon "sticky-note"              :face icons-in-terminal-lyellow)
    ("^\\*scratch.*"    icons-in-terminal-faicon "sticky-note"              :face icons-in-terminal-yellow)
    ("^\\*new-tab\\*$"  icons-in-terminal-material "star"                   :face icons-in-terminal-cyan)

    ("^\\."             icons-in-terminal-octicon "gear"                    :v-adjust 0.0)
    ("."                icons-in-terminal-faicon "file-o"                   :height 0.8 :v-adjust 0.0 :face icons-in-terminal-dsilver)))

(defvar icons-in-terminal-dir-icon-spec
  '(
    ("trash"            icons-in-terminal-faicon "trash-o"          :height 1.2 :v-adjust -0.1)
    ("dropbox"          icons-in-terminal-faicon "dropbox"          :height 1.0 :v-adjust -0.1)
    ("google[ _-]drive" icons-in-terminal-fileicon "google-drive" :height 1.3 :v-adjust -0.1)
    ("^atom$"           icons-in-terminal-fileicon "atom"         :height 1.2 :v-adjust -0.1)
    ("documents"        icons-in-terminal-faicon "book"             :height 1.0 :v-adjust -0.1)
    ("download"         icons-in-terminal-faicon "cloud-download"   :height 0.9 :v-adjust -0.2)
    ("desktop"          icons-in-terminal-octicon "device-desktop"  :height 1.0 :v-adjust -0.1)
    ("pictures"         icons-in-terminal-faicon "picture-o"        :height 0.9 :v-adjust -0.2)
    ("photos"           icons-in-terminal-faicon "camera-retro"     :height 1.0 :v-adjust -0.1)
    ("music"            icons-in-terminal-faicon "music"            :height 1.0 :v-adjust -0.1)
    ("movies"           icons-in-terminal-faicon "film"             :height 0.9 :v-adjust -0.1)
    ("code"             icons-in-terminal-octicon "code"            :height 1.1 :v-adjust -0.1)
    ("workspace"        icons-in-terminal-octicon "code"            :height 1.1 :v-adjust -0.1)
    ("test"             icons-in-terminal-fileicon "test-dir"       :height 0.9)
    ("\\.git"           icons-in-terminal-fileicon "git"            :height 1.0 :v-adjust -0.1)
    ("."                icons-in-terminal-octicon "file-directory"  :height 1.0 :v-adjust -0.1)
    ))

(defvar icons-in-terminal-weather-icon-spec
  '(
    ("tornado"               icons-in-terminal-weather "tornado")
    ("hurricane"             icons-in-terminal-weather "hurricane")
    ("thunderstorms"         icons-in-terminal-weather "thunderstorm")
    ("sunny"                 icons-in-terminal-weather "day-sunny")
    ("rain.*snow"            icons-in-terminal-weather "rain-mix")
    ("rain.*hail"            icons-in-terminal-weather "rain-mix")
    ("sleet"                 icons-in-terminal-weather "sleet")
    ("hail"                  icons-in-terminal-weather "hail")
    ("drizzle"               icons-in-terminal-weather "sprinkle")
    ("rain"                  icons-in-terminal-weather "showers" :height 1.1 :v-adjust 0.0)
    ("showers"               icons-in-terminal-weather "showers")
    ("blowing.*snow"         icons-in-terminal-weather "snow-wind")
    ("snow"                  icons-in-terminal-weather "snow")
    ("dust"                  icons-in-terminal-weather "dust")
    ("fog"                   icons-in-terminal-weather "fog")
    ("haze"                  icons-in-terminal-weather "day-haze")
    ("smoky"                 icons-in-terminal-weather "smoke")
    ("blustery"              icons-in-terminal-weather "cloudy-windy")
    ("windy"                 icons-in-terminal-weather "cloudy-gusts")
    ("cold"                  icons-in-terminal-weather "snowflake-cold")
    ("partly.*cloudy.*night" icons-in-terminal-weather "night-alt-partly-cloudy")
    ("partly.*cloudy"        icons-in-terminal-weather "day-cloudy-high")
    ("cloudy.*night"         icons-in-terminal-weather "night-alt-cloudy")
    ("cxloudy.*day"          icons-in-terminal-weather "day-cloudy")
    ("cloudy"                icons-in-terminal-weather "cloudy")
    ("clear.*night"          icons-in-terminal-weather "night-clear")
    ("fair.*night"           icons-in-terminal-weather "stars")
    ("fair.*day"             icons-in-terminal-weather "horizon")
    ("hot"                   icons-in-terminal-weather "hot")
    ("not.*available"        icons-in-terminal-weather "na")
    ))

(defvar icons-in-terminal-mode-icon-spec
  '(
    (emacs-lisp-mode           icons-in-terminal-fileicon "elisp"              :height 1.0 :v-adjust -0.2 :face icons-in-terminal-purple)
    (erc-mode                  icons-in-terminal-faicon "commenting-o"         :height 1.0 :v-adjust 0.0 :face icons-in-terminal-white)
    (inferior-emacs-lisp-mode  icons-in-terminal-fileicon "elisp"              :height 1.0 :v-adjust -0.2 :face icons-in-terminal-lblue)
    (dired-mode                icons-in-terminal-octicon "file-directory"      :v-adjust 0.0)
    (lisp-interaction-mode     icons-in-terminal-fileicon "lisp"               :v-adjust -0.1 :face icons-in-terminal-orange)
    (sly-mrepl-mode            icons-in-terminal-fileicon "clisp"               :v-adjust -0.1 :face icons-in-terminal-orange)
    (slime-repl-mode           icons-in-terminal-fileicon "clisp"               :v-adjust -0.1 :face icons-in-terminal-orange)
    (org-mode                  icons-in-terminal-fileicon "org"                :v-adjust 0.0 :face icons-in-terminal-lgreen)
    (typescript-mode           icons-in-terminal-fileicon "typescript"         :v-adjust -0.1 :face icons-in-terminal-blue-alt)
    (js-mode                   icons-in-terminal-fileicon "javascript"       :v-adjust -0.1 :face icons-in-terminal-yellow)
    (js-jsx-mode               icons-in-terminal-fileicon "javascript"       :v-adjust -0.1 :face icons-in-terminal-yellow)
    (js2-mode                  icons-in-terminal-fileicon "javascript"       :v-adjust -0.1 :face icons-in-terminal-yellow)
    (js3-mode                  icons-in-terminal-fileicon "javascript"       :v-adjust -0.1 :face icons-in-terminal-yellow)
    (rjsx-mode                 icons-in-terminal-fileicon "jsx-2"              :v-adjust -0.1 :face icons-in-terminal-cyan-alt)
    (term-mode                 icons-in-terminal-octicon "terminal"            :v-adjust 0.2)
    (eshell-mode               icons-in-terminal-octicon "terminal"            :v-adjust 0.0 :face icons-in-terminal-purple)
    (magit-refs-mode           icons-in-terminal-octicon "git-branch"          :v-adjust 0.0 :face icons-in-terminal-red)
    (magit-process-mode        icons-in-terminal-octicon "mark-github"         :v-adjust 0.0)
    (magit-diff-mode           icons-in-terminal-octicon "git-compare"         :v-adjust 0.0 :face icons-in-terminal-lblue)
    (ediff-mode                icons-in-terminal-octicon "git-compare"         :v-adjust 0.0 :Face icons-in-terminal-red)
    (comint-mode               icons-in-terminal-faicon "terminal"             :v-adjust 0.0 :face icons-in-terminal-lblue)
    (eww-mode                  icons-in-terminal-faicon "firefox"              :v-adjust -0.1 :face icons-in-terminal-red)
    (org-agenda-mode           icons-in-terminal-octicon "checklist"           :v-adjust 0.0 :face icons-in-terminal-lgreen)
    (cfw:calendar-mode         icons-in-terminal-octicon "calendar"            :v-adjust 0.0)
    (ibuffer-mode              icons-in-terminal-faicon "files-o"              :v-adjust 0.0 :face icons-in-terminal-dsilver)
    (messages-buffer-mode      icons-in-terminal-faicon "stack-overflow"       :v-adjust -0.1)
    (help-mode                 icons-in-terminal-faicon "info"                 :v-adjust -0.1 :face icons-in-terminal-purple)
    (benchmark-init/tree-mode  icons-in-terminal-octicon "dashboard"           :v-adjust 0.0)
    (jenkins-mode              icons-in-terminal-fileicon "jenkins"            :face icons-in-terminal-blue)
    (magit-popup-mode          icons-in-terminal-fileicon "git"                :face icons-in-terminal-red)
    (magit-status-mode         icons-in-terminal-fileicon "git"                :face icons-in-terminal-lred)
    (magit-log-mode            icons-in-terminal-fileicon "git"                :face icons-in-terminal-green)
    (paradox-menu-mode         icons-in-terminal-faicon "archive"              :height 1.0 :v-adjust 0.0 :face icons-in-terminal-silver)
    (Custom-mode               icons-in-terminal-octicon "settings")

    ;; Special matcher for Web Mode based on the `web-mode-content-type' of the current buffer
    (web-mode             icons-in-terminal--web-mode-icon)

    (fundamental-mode                   icons-in-terminal-fileicon "elisp"            :height 1.0 :v-adjust -0.2 :face icons-in-terminal-dsilver)
    (special-mode                       icons-in-terminal-fileicon "elisp"            :height 1.0 :v-adjust -0.2 :face icons-in-terminal-yellow)
    (text-mode                          icons-in-terminal-octicon "file-text"         :v-adjust 0.0 :face icons-in-terminal-cyan)
    (ruby-mode                          icons-in-terminal-fileicon "ruby-alt"       :face icons-in-terminal-lred)
    (inf-ruby-mode                      icons-in-terminal-fileicon "ruby-alt"       :face icons-in-terminal-red)
    (projectile-rails-compilation-mode  icons-in-terminal-fileicon "ruby-alt"       :face icons-in-terminal-red)
    (rspec-compilation-mode             icons-in-terminal-fileicon "ruby-alt"       :face icons-in-terminal-red)
    (rake-compilation-mode              icons-in-terminal-fileicon "ruby-alt"       :face icons-in-terminal-red)
    (sh-mode                            icons-in-terminal-fileicon "terminal"       :face icons-in-terminal-purple)
    (shell-mode                         icons-in-terminal-fileicon "terminal"       :face icons-in-terminal-purple)
    (fish-mode                          icons-in-terminal-fileicon "terminal"       :face icons-in-terminal-lpink)
    (nginx-mode                         icons-in-terminal-fileicon "nginx"            :height 0.9  :face icons-in-terminal-dgreen)
    (apache-mode                        icons-in-terminal-fileicon "apache"         :height 0.9  :face icons-in-terminal-dgreen)
    (makefile-mode                      icons-in-terminal-fileicon "gnu"              :face icons-in-terminal-dorange)
    (dockerfile-mode                    icons-in-terminal-fileicon "dockerfile"       :face icons-in-terminal-blue)
    (docker-compose-mode                icons-in-terminal-fileicon "dockerfile"       :face icons-in-terminal-lblue)
    (xml-mode                           icons-in-terminal-faicon "file-code-o"        :height 0.95 :face icons-in-terminal-lorange)
    (json-mode                          icons-in-terminal-octicon "settings"          :face icons-in-terminal-yellow)
    (yaml-mode                          icons-in-terminal-octicon "settings"          :v-adjust 0.0 :face icons-in-terminal-dyellow)
    (elisp-byte-code-mode               icons-in-terminal-octicon "file-binary"       :v-adjust 0.0 :face icons-in-terminal-dsilver)
    (archive-mode                       icons-in-terminal-octicon "file-zip"          :v-adjust 0.0 :face icons-in-terminal-lmaroon)
    (elm-mode                           icons-in-terminal-fileicon "elm"              :face icons-in-terminal-blue)
    (erlang-mode                        icons-in-terminal-fileicon "erlang"         :face icons-in-terminal-red :v-adjust -0.1 :height 0.9)
    (elixir-mode                        icons-in-terminal-fileicon "elixir"         :face icons-in-terminal-lorange :v-adjust -0.1 :height 0.9)
    (java-mode                          icons-in-terminal-fileicon "java"           :height 1.0  :face icons-in-terminal-purple)
    (go-mode                            icons-in-terminal-fileicon "go"             :height 1.0  :face icons-in-terminal-blue)
    (matlab-mode                        icons-in-terminal-fileicon "matlab"           :face icons-in-terminal-orange)
    (perl-mode                          icons-in-terminal-fileicon "perl"           :face icons-in-terminal-lorange)
    (cperl-mode                         icons-in-terminal-fileicon "perl"           :face icons-in-terminal-lorange)
    (php-mode                           icons-in-terminal-fileicon "php"              :face icons-in-terminal-lsilver)
    (prolog-mode                        icons-in-terminal-fileicon "prolog"         :height 1.1  :face icons-in-terminal-lmaroon)
    (python-mode                        icons-in-terminal-fileicon "python"         :height 1.0  :face icons-in-terminal-dblue)
    (inferior-python-mode               icons-in-terminal-fileicon "python"         :height 1.0  :face icons-in-terminal-dblue)
    (racket-mode                        icons-in-terminal-fileicon "racket"           :height 1.2 :face icons-in-terminal-red)
    (rust-mode                          icons-in-terminal-fileicon "rust"           :height 1.2  :face icons-in-terminal-maroon)
    (scala-mode                         icons-in-terminal-fileicon "scala"          :face icons-in-terminal-red)
    (scheme-mode                        icons-in-terminal-fileicon   "scheme"         :height 1.2 :face icons-in-terminal-red)
    (swift-mode                         icons-in-terminal-fileicon "swift"          :height 1.0 :v-adjust -0.1 :face icons-in-terminal-green)
    (c-mode                             icons-in-terminal-fileicon "c-line"         :face icons-in-terminal-blue)
    (c++-mode                           icons-in-terminal-fileicon "cplusplus-line" :v-adjust -0.2 :face icons-in-terminal-blue)
    (csharp-mode                        icons-in-terminal-fileicon "csharp-line"    :face icons-in-terminal-dblue)
    (clojure-mode                       icons-in-terminal-fileicon "clojure-line"   :height 1.0  :face icons-in-terminal-blue)
    (cider-repl-mode                    icons-in-terminal-fileicon "clojure-line"   :height 1.0  :face icons-in-terminal-dblue)
    (clojurescript-mode                 icons-in-terminal-fileicon "cljs"             :height 1.0  :face icons-in-terminal-dblue)
    (coffee-mode                        icons-in-terminal-fileicon "coffeescript"   :height 1.0  :face icons-in-terminal-maroon)
    (lisp-mode                          icons-in-terminal-fileicon "lisp"             :face icons-in-terminal-orange)
    (css-mode                           icons-in-terminal-fileicon "css3"           :face icons-in-terminal-yellow)
    (scss-mode                          icons-in-terminal-fileicon "sass"           :face icons-in-terminal-pink)
    (sass-mode                          icons-in-terminal-fileicon "sass"           :face icons-in-terminal-dpink)
    (less-css-mode                      icons-in-terminal-fileicon "less"           :height 0.8  :face icons-in-terminal-dyellow)
    (stylus-mode                        icons-in-terminal-fileicon "stylus"         :face icons-in-terminal-lgreen)
    (csv-mode                           icons-in-terminal-octicon "graph"             :v-adjust 0.0 :face icons-in-terminal-dblue)
    (haskell-mode                       icons-in-terminal-fileicon "haskell"        :height 1.0  :face icons-in-terminal-red)
    (haml-mode                          icons-in-terminal-fileicon "haml"             :face icons-in-terminal-lyellow)
    (html-mode                          icons-in-terminal-fileicon "html5"          :face icons-in-terminal-orange)
    (rhtml-mode                         icons-in-terminal-fileicon "html5"          :face icons-in-terminal-lred)
    (mustache-mode                      icons-in-terminal-fileicon "moustache"        :face icons-in-terminal-green)
    (slim-mode                          icons-in-terminal-octicon "dashboard"         :v-adjust 0.0 :face icons-in-terminal-yellow)
    (jade-mode                          icons-in-terminal-fileicon "jade"             :face icons-in-terminal-red)
    (pug-mode                           icons-in-terminal-fileicon "pug"              :face icons-in-terminal-red)
    (react-mode                         icons-in-terminal-fileicon "react"          :height 1.1  :face icons-in-terminal-lblue)
    (image-mode                         icons-in-terminal-octicon "file-media"        :v-adjust 0.0 :face icons-in-terminal-blue)
    (texinfo-mode                       icons-in-terminal-fileicon "tex"              :face icons-in-terminal-lred)
    (markdown-mode                      icons-in-terminal-octicon "markdown"          :v-adjust 0.0 :face icons-in-terminal-lblue)
    (bibtex-mode                        icons-in-terminal-fileicon "bib"              :face icons-in-terminal-maroon)
    (org-mode                           icons-in-terminal-fileicon "org"              :face icons-in-terminal-lgreen)
    (compilation-mode                   icons-in-terminal-faicon "cogs"               :v-adjust 0.0 :height 1.0)
    (objc-mode                          icons-in-terminal-faicon "apple"              :v-adjust 0.0 :height 1.0)
    (tuareg-mode                        icons-in-terminal-fileicon "ocaml"            :v-adjust 0.0 :height 1.0)
    (purescript-mode                    icons-in-terminal-fileicon "purescript"       :v-adjust 0.0 :height 1.0)
    ))

(defvar icons-in-terminal-url-spec
  '(
    ;; Social media and communities
    ("^\\(https?://\\)?\\(www\\.\\)?del\\.icio\\.us" icons-in-terminal-faicon "delicious")
    ("^\\(https?://\\)?\\(www\\.\\)?behance\\.net" icons-in-terminal-faicon "behance")
    ("^\\(https?://\\)?\\(www\\.\\)?dribbble\\.com" icons-in-terminal-faicon "dribbble")
    ("^\\(https?://\\)?\\(www\\.\\)?facebook\\.com" icons-in-terminal-faicon "facebook-official")
    ("^\\(https?://\\)?\\(www\\.\\)?glide\\.me" icons-in-terminal-faicon "glide-g")
    ("^\\(https?://\\)?\\(www\\.\\)?plus\\.google\\.com" icons-in-terminal-faicon "google-plus")
    ("linkedin\\.com" icons-in-terminal-faicon "linkedin")
    ("^\\(https?://\\)?\\(www\\.\\)?ok\\.ru" icons-in-terminal-faicon "odnoklassniki")
    ("^\\(https?://\\)?\\(www\\.\\)?reddit\\.com" icons-in-terminal-faicon "reddit-alien")
    ("^\\(https?://\\)?\\(www\\.\\)?slack\\.com" icons-in-terminal-faicon "slack")
    ("^\\(https?://\\)?\\(www\\.\\)?snapchat\\.com" icons-in-terminal-faicon "snapchat-ghost")
    ("^\\(https?://\\)?\\(www\\.\\)?weibo\\.com" icons-in-terminal-faicon "weibo")
    ("^\\(https?://\\)?\\(www\\.\\)?twitter\\.com" icons-in-terminal-faicon "twitter")
    ;; Blogging
    ("joomla\\.org" icons-in-terminal-faicon "joomla")
    ("^\\(https?://\\)?\\(www\\.\\)?medium\\.com" icons-in-terminal-faicon "medium")
    ("tumblr\\.com" icons-in-terminal-faicon "tumblr")
    ("^wordpress\\.com" icons-in-terminal-faicon "wordpress")
    ;; Programming
    ("^\\(https?://\\)?\\(www\\.\\)?bitbucket\\.org" icons-in-terminal-octicon "bitbucket")
    ("^\\(https?://\\)?\\(www\\.\\)?codepen\\.io" icons-in-terminal-faicon "codepen")
    ("^\\(https?://\\)?\\(www\\.\\)?codiepie\\.com" icons-in-terminal-faicon "codiepie")
    ("^\\(https?://\\)?\\(www\\.\\)?gist\\.github\\.com" icons-in-terminal-octicon "gist")
    ("^\\(https?://\\)?\\(www\\.\\)?github\\.com" icons-in-terminal-octicon "mark-github")
    ("^\\(https?://\\)?\\(www\\.\\)?gitlab\\.com" icons-in-terminal-faicon "gitlab")
    ("^\\(https?://\\)?\\(www\\.\\)?news\\.ycombinator\\.com" icons-in-terminal-faicon "hacker-news")
    ("^\\(https?://\\)?\\(www\\.\\)?jsfiddle\\.net" icons-in-terminal-faicon "jsfiddle")
    ("^\\(https?://\\)?\\(www\\.\\)?maxcdn\\.com" icons-in-terminal-faicon "maxcdn")
    ("^\\(https?://\\)?\\(www\\.\\)?stackoverflow\\.com" icons-in-terminal-faicon "stack-overflow")
    ;; Video
    ("^\\(https?://\\)?\\(www\\.\\)?twitch\\.tv" icons-in-terminal-faicon "twitch")
    ("^\\(https?://\\)?\\(www\\.\\)?vimeo\\.com" icons-in-terminal-faicon "vimeo")
    ("^\\(https?://\\)?\\(www\\.\\)?youtube\\.com" icons-in-terminal-faicon "youtube")
    ("^\\(https?://\\)?\\(www\\.\\)?youtu\\.be" icons-in-terminal-faicon "youtube")
    ("^\\(https?://\\)?\\(www\\.\\)?vine\\.co" icons-in-terminal-faicon "vine")
    ;; Sound
    ("^\\(https?://\\)?\\(www\\.\\)?last\\.fm" icons-in-terminal-faicon "lastfm")
    ("^\\(https?://\\)?\\(www\\.\\)?mixcloud\\.com" icons-in-terminal-faicon "mixcloud")
    ("^\\(https?://\\)?\\(www\\.\\)?soundcloud\\.com" icons-in-terminal-faicon "soundcloud")
    ("spotify\\.com" icons-in-terminal-faicon "spotify")
    ;; Shopping
    ("^\\(https?://\\)?\\(www\\.\\)?amazon\\." icons-in-terminal-faicon "amazon")
    ("^\\(https?://\\)?\\(www\\.\\)?opencart\\.com" icons-in-terminal-faicon "opencart")
    ("^\\(https?://\\)?\\(www\\.\\)?paypal\\.com" icons-in-terminal-faicon "paypal")
    ("^\\(https?://\\)?\\(www\\.\\)?shirtsinbulk\\.com" icons-in-terminal-faicon "shitsinbulk")
    ;; Images
    ("^\\(https?://\\)?\\(www\\.\\)?500px\\.com" icons-in-terminal-faicon "500px")
    ("^\\(https?://\\)?\\(www\\.\\)?deviantart\\.com" icons-in-terminal-faicon "deviantart")
    ("^\\(https?://\\)?\\(www\\.\\)?flickr\\.com" icons-in-terminal-faicon "flickr")
    ("^\\(https?://\\)?\\(www\\.\\)?instagram\\.com" icons-in-terminal-faicon "instagram")
    ("^\\(https?://\\)?\\(www\\.\\)?pinterest\\." icons-in-terminal-faicon "pinterest")
    ;; Information and books
    ("^\\(https?://\\)?\\(www\\.\\)?digg\\.com" icons-in-terminal-faicon "digg")
    ("^\\(https?://\\)?\\(www\\.\\)?foursquare\\.com" icons-in-terminal-faicon "foursquare")
    ("^\\(https?://\\)?\\(www\\.\\)?getpocket\\.com" icons-in-terminal-faicon "get-pocket")
    ("^\\(https?://\\)?\\(www\\.\\)?scribd\\.com" icons-in-terminal-faicon "scribd")
    ("^\\(https?://\\)?\\(www\\.\\)?slideshare\\.net" icons-in-terminal-faicon "slideshare")
    ("stackexchange\\.com" icons-in-terminal-faicon "stack-exchange")
    ("^\\(https?://\\)?\\(www\\.\\)?stumbleupon\\.com" icons-in-terminal-faicon "stumbleupon")
    ("^\\(https?://\\)?\\(www\\.\\)?tripadvisor\\." icons-in-terminal-faicon "tripadvisor")
    ("^\\(https?://\\)?\\(www\\.\\)?yelp\\." icons-in-terminal-faicon "yelp")

    ("wikipedia\\.org" icons-in-terminal-faicon "wikipedia-w")
    ;; Various companies and tools
    ("^\\(https?://\\)?\\(www\\.\\)?angel\\.co" icons-in-terminal-faicon "angellist")
    ("^\\(https?://\\)?\\(www\\.\\)?apple\\.com" icons-in-terminal-faicon "apple")
    ("^\\(https?://\\)?\\(www\\.\\)?buysellads\\.com" icons-in-terminal-faicon "buysellads")
    ("^\\(https?://\\)?\\(www\\.\\)?connectdevelop\\.com" icons-in-terminal-faicon "connectdevelop")
    ("^\\(https?://\\)?\\(www\\.\\)?dashcube\\.com" icons-in-terminal-faicon "dashcube")
    ("^\\(https?://\\)?\\(www\\.\\)?dropbox\\.com" icons-in-terminal-faicon "dropbox")
    ("^\\(https?://\\)?\\(www\\.\\)?enviragallery\\.com" icons-in-terminal-faicon "envira")
    ("^\\(https?://\\)?\\(www\\.\\)?fortawesome\\.com" icons-in-terminal-faicon "fort-awesome")
    ("^\\(https?://\\)?\\(www\\.\\)?forumbee\\.com" icons-in-terminal-faicon "forumbee")
    ("^\\(https?://\\)?\\(www\\.\\)?gratipay\\.com" icons-in-terminal-faicon "gratipay")
    ("^\\(https?://\\)?\\(www\\.\\)?modx\\.com" icons-in-terminal-faicon "modx")
    ("^\\(https?://\\)?\\(www\\.\\)?pagelines\\.com" icons-in-terminal-faicon "pagelines")
    ("^\\(https?://\\)?\\(www\\.\\)?producthunt\\.com" icons-in-terminal-faicon "product-hunt")
    ("sellsy\\.com" icons-in-terminal-faicon "sellsy")
    ("^\\(https?://\\)?\\(www\\.\\)?simplybuilt\\.com" icons-in-terminal-faicon "simplybuilt")
    ("^\\(https?://\\)?\\(www\\.\\)?skyatlas\\.com" icons-in-terminal-faicon "skyatlas")
    ("^\\(https?://\\)?\\(www\\.\\)?skype\\.com" icons-in-terminal-faicon "skype")
    ("steampowered\\.com" icons-in-terminal-faicon "steam")
    ("^\\(https?://\\)?\\(www\\.\\)?themeisle\\.com" icons-in-terminal-faicon "themeisle")
    ("^\\(https?://\\)?\\(www\\.\\)?trello\\.com" icons-in-terminal-faicon "trello")
    ("^\\(https?://\\)?\\(www\\.\\)?whatsapp\\.com" icons-in-terminal-faicon "whatsapp")
    ("^\\(https?://\\)?\\(www\\.\\)?ycombinator\\.com" icons-in-terminal-faicon "y-combinator")
    ("yahoo\\.com" icons-in-terminal-faicon "yahoo")
    ("^\\(https?://\\)?\\(www\\.\\)?yoast\\.com" icons-in-terminal-faicon "yoast")
    ;; Catch all
    ("android" icons-in-terminal-faicon "android")
    ("creativecommons" icons-in-terminal-faicon "creative-commons")
    ("forums?" icons-in-terminal-octicon "comment-discussion")
    ("\\.pdf$" icons-in-terminal-octicon "file-pdf" :v-adjust 0.0 :face icons-in-terminal-dred)
    ("google" icons-in-terminal-faicon "google")
    ("\\.rss" icons-in-terminal-faicon "rss")
    ))

;;; Functions

(defun icons-in-terminal-auto-mode-match? (&optional file)
  "Whether or not FILE's `major-mode' match against its `auto-mode-alist'."
  (let* ((file (or file (buffer-file-name) (buffer-name)))
         (auto-mode (icons-in-terminal-match-to-alist file auto-mode-alist)))
    (eq major-mode auto-mode)))

(defun icons-in-terminal-match-to-alist (file alist)
  "Match FILE against an entry in ALIST using `string-match'."
  (cdr (cl-find-if (lambda (it) (string-match (car it) file)) alist)))

(defun icons-in-terminal--read-candidates ()
  "Helper to build a list of candidates for all families."
  (cl-reduce 'append (mapcar (lambda (it) (icons-in-terminal--read-candidates-for-family (car it) t)) icons-in-terminal-alist)))

(defun icons-in-terminal--read-candidates-for-family (family &optional show-family)
  "Helper to build read candidates for FAMILY.
If SHOW-FAMILY is non-nil, displays the icons family in the candidate string."
  (let ((data   (cdr (assoc family icons-in-terminal-alist)))
        (icon-f (icons-in-terminal--function-name family)))
    (mapcar
     (lambda (it)
       (let* ((icon-name (car it))
              (icon-name-head (substring icon-name 0 1))
              (icon-name-tail (substring icon-name 1))

              (icon-display (propertize icon-name-head 'display (format "%s\t%s" (funcall icon-f icon-name) icon-name-head)))
              (icon-family (if show-family (format "\t[%s]" family) ""))

              (candidate-name (format "%s%s%s" icon-display icon-name-tail icon-family))
              (candidate-icon (funcall (icons-in-terminal--function-name family) icon-name)))

         (cons candidate-name candidate-icon)))
     data)))

(defun icons-in-terminal-dir-is-submodule (dir)
  "Checker whether or not DIR is a git submodule."
  (let* ((gitmodule-dir (locate-dominating-file dir ".gitmodules"))
         (modules-file  (expand-file-name (format "%s.gitmodules" gitmodule-dir)))
         (module-search (format "submodule \".*?%s\"" (file-name-base dir))))

    (when (and gitmodule-dir (file-exists-p (format "%s/.git" dir)))
      (with-temp-buffer
        (insert-file-contents modules-file)
        (search-forward-regexp module-search (point-max) t)))))

;; Family Face Functions
(defun icons-in-terminal-icon-family-for-file (file)
  "Get the icons font family for FILE."
  (let ((icon (icons-in-terminal-match-to-alist file icons-in-terminal-icon-spec)))
    (funcall (intern (format "%s-family" (car icon))))))

(defun icons-in-terminal-icon-family-for-mode (mode)
  "Get the icons font family for MODE."
  (let ((icon (cdr (assoc mode icons-in-terminal-mode-icon-spec))))
    (if icon (funcall (intern (format "%s-family" (car icon)))) nil)))

(defun icons-in-terminal-icon-family (icon)
  "Get a propertized ICON family programatically."
  (plist-get (get-text-property 0 'face icon) :family))

;;;###autoload
(defun icons-in-terminal-insert (&optional arg family)
  "Interactive icon insertion function.
When Prefix ARG is non-nil, insert the propertized icon.
When FAMILY is non-nil, limit the candidates to the icon set matching it."
  (interactive "P")
  (let* ((standard-output (current-buffer))
         (candidates (if family
                         (icons-in-terminal--read-candidates-for-family family)
                       (icons-in-terminal--read-candidates)))
         (prompt     (if family
                         (format "%s Icon: " (funcall (icons-in-terminal--family-name family)))
                       "Icon : "))

         (selection (completing-read prompt candidates nil t))
         (result    (cdr (assoc selection candidates))))

    (if arg (prin1 result) (insert result))))

;;;###autoload
(defun icons-in-terminal--icon-info-for-buffer (&optional f)
  "Get icon info for the current buffer.

When F is provided, the info function is calculated with the format
`icons-in-terminal-icon-%s-for-file' or `icons-in-terminal-icon-%s-for-mode'."
  (let* ((base-f (concat "icons-in-terminal-icon" (when f (format "-%s" f))))
         (file-f (intern (concat base-f "-for-file")))
         (mode-f (intern (concat base-f "-for-mode"))))
    (if (and (buffer-file-name)
             (icons-in-terminal-auto-mode-match?))
        (funcall file-f (file-name-nondirectory (buffer-file-name)))
      (funcall mode-f major-mode))))

;;;###autoload
(defun icons-in-terminal-icon-for-file (file &rest arg-overrides)
  "Get the formatted icon for FILE.
ARG-OVERRIDES should be a plist containning `:height',
`:v-adjust' or `:face' properties like the normal icon
inserting functions."
  (let* ((icon (icons-in-terminal-match-to-alist file icons-in-terminal-icon-spec))
         (args (cdr icon)))
    (when arg-overrides (setq args (append `(,(car args)) arg-overrides (cdr args))))
    (apply (car icon) args)))

;;;###autoload
(defun icons-in-terminal-icon-for-mode (mode &rest arg-overrides)
  "Get the formatted icon for MODE.
ARG-OVERRIDES should be a plist containining `:height',
`:v-adjust' or `:face' properties like in the normal icon
inserting functions."
  (let* ((icon (cdr (or (assoc mode icons-in-terminal-mode-icon-spec)
                        (assoc (get mode 'derived-mode-parent) icons-in-terminal-mode-icon-spec))))
         (args (cdr icon)))
    (when arg-overrides (setq args (append `(,(car args)) arg-overrides (cdr args))))
    (if icon (apply (car icon) args) mode)))

;;;###autoload
(defun icons-in-terminal-icon-for-buffer ()
  "Get the formatted icon for the current buffer.

This function prioritises the use of the buffers file extension to
discern the icon when its `major-mode' matches its auto mode,
otherwise it will use the buffers `major-mode' to decide its
icon."
  (icons-in-terminal--icon-info-for-buffer))

;;;###autoload
(defun icons-in-terminal-icon-for-dir (dir &optional chevron padding)
  "Format an icon for DIR with CHEVRON similar to tree based directories.

If PADDING is provided, it will prepend and separate the chevron
and directory with PADDING.

Produces different symbols by inspecting DIR to distinguish
symlinks and git repositories which do not depend on the
directory contents"
  (let* ((matcher (icons-in-terminal-match-to-alist (file-name-base (directory-file-name dir)) icons-in-terminal-dir-icon-spec))
         (path (expand-file-name dir))
         (chevron (if chevron (icons-in-terminal-octicon (format "chevron-%s" chevron) :height 0.8 :v-adjust -0.1) ""))
         (padding (or padding "\t"))
         (icon (cond
                ((file-symlink-p path)
                 (icons-in-terminal-octicon "file-symlink-directory" :height 1.0))
                ((icons-in-terminal-dir-is-submodule path)
                 (icons-in-terminal-octicon "file-submodule" :height 1.0))
                ((file-exists-p (format "%s/.git" path))
                 (format "%s" (icons-in-terminal-octicon "repo" :height 1.1)))
                (t (apply (car matcher) (cdr matcher))))))
    (format "%s%s%s%s%s" padding chevron padding icon padding)))

;;;###autoload
(defun icons-in-terminal-icon-for-url (url &rest arg-overrides)
  "Get the formatted icon for URL.
If an icon for URL isn't found in `icons-in-terminal-url-spec', a globe is used.
ARG-OVERRIDES should be a plist containining `:height',
`:v-adjust' or `:face' properties like in the normal icon
inserting functions."
  (let* ((icon (icons-in-terminal-match-to-alist url icons-in-terminal-url-spec))
         (args (cdr icon)))
    (unless icon
      (setq icon '(icons-in-terminal-faicon "globe"))
      (setq args (cdr icon)))
    (when arg-overrides (setq args (append `(,(car args)) arg-overrides (cdr args))))
    (apply (car icon) args)))

;;;###autoload
(defun icons-in-terminal-icon-for-weather (weather)
  "Get an icon for a WEATHER status."
  (let ((icon (icons-in-terminal-match-to-alist weather icons-in-terminal-weather-icon-spec)))
    (if icon (apply (car icon) (cdr icon)) weather)))

;;; Initialize

(eval-and-compile
  (defun icons-in-terminal--function-name (name)
    "Get the symbol for an icon function name for icon set NAME."
    (intern (concat "icons-in-terminal-" (downcase (symbol-name name)))))

  (defun icons-in-terminal--family-name (name)
    "Get the symbol for an icon family function for icon set NAME."
    (intern (concat "icons-in-terminal-" (downcase (symbol-name name)) "-family")))

  (defun icons-in-terminal--insert-function-name (name)
    "Get the symbol for an icon insert function for icon set NAME."
    (intern (concat "icons-in-terminal-insert-" (downcase (symbol-name name))))))

(defmacro icons-in-terminal--define-icon (name alist family &optional font-name)
  "Macro to generate functions for inserting icons for icon set NAME.

NAME defines is the name of the iconset and will produce a
function of the for `icons-in-terminal-NAME'.

ALIST is the alist containing maps between icon names and the
UniCode for the character.  All of these can be found in the data
directory of this package.

FAMILY is the font family to use for the icons.
FONT-NAME is the name of the .ttf file providing the font, defaults to FAMILY."
  `(progn
     (defun ,(icons-in-terminal--family-name name) () ,family)
     (defun ,(icons-in-terminal--function-name name) (icon-name &rest args)
       (let ((icon (cdr (assoc icon-name ,alist)))
             (other-face (when icons-in-terminal-color-icons (plist-get args :face)))
             (height  (* icons-in-terminal-scale-factor (or (plist-get args :height) 1.0)))
             (v-adjust (* icons-in-terminal-scale-factor (or (plist-get args :v-adjust) icons-in-terminal-default-adjust)))
             (family ,family))
         (unless icon
           (error (format "Unable to find icon with name `%s' in icon set `%s'" icon-name (quote ,name))))
         (let ((face (if other-face
                         `(:family ,family :height ,height :inherit ,other-face)
                       `(:family ,family :height ,height))))
           (propertize icon
                       'face face           ;so that this works without `font-lock-mode' enabled
                       'font-lock-face face ;so that `font-lock-mode' leaves this alone
                       'display `(raise ,v-adjust)
                       'rear-nonsticky t))))
     (defun ,(icons-in-terminal--insert-function-name name) (&optional arg)
       ,(format "Insert a %s icon at point." family)
       (interactive "P")
       (icons-in-terminal-insert arg (quote ,name)))))

(icons-in-terminal--define-icon fileicon icons-in-terminal-alist/fileicon "icons-in-terminal")
(icons-in-terminal--define-icon faicon   icons-in-terminal-alist/faicon   "icons-in-terminal")
(icons-in-terminal--define-icon octicon  icons-in-terminal-alist/octicon  "icons-in-terminal")
(icons-in-terminal--define-icon weather  icons-in-terminal-alist/weather  "icons-in-terminal")
(icons-in-terminal--define-icon material icons-in-terminal-alist/material "icons-in-terminal")

(provide 'icons-in-terminal)

;;; icons-in-terminal.el ends here
