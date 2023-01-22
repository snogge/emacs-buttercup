;;; test-substitute-quotes.el ---                    -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Axis Communications AB

;; Author: Ola x Nilsson <ola.x.nilsson@axis.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'buttercup)

(describe "The `substitute-quotes' function"
  (it "is controlled by `text-quoting-style'"
	(assume (fboundp 'text-quoting-style))
	(expect (text-quoting-style) :to-equal 'curve))
  (it "should replace quotes"
	(assume (fboundp 'substitute-quotes))
	(expect (substitute-quotes "`foo'") :to-equal "‘foo’"))
  (it "should replace quotes in `user-error' messages"
	(assume (fboundp 'substitute-quotes))
	(expect (user-error "`bar'") :to-throw 'user-error '("‘bar’")))
  (it "should think UTF-8 is available"
	(assume (boundp 'internal--text-quoting-flag))
	(expect internal--text-quoting-flag))
  (it "should find `standard-display-table' nil"
	(expect standard-display-table :to-be nil))
  (it "should be possible to force quoting style `grave'"
	(expect (let ((text-quoting-style 'grave))
			  (user-error "`bar'"))
			:to-throw 'user-error '("`bar'")))
  (describe "use buttercup vars to control quote substitution"
	:var ((text-quoting-style 'grave))
	(it "should use `grave' quote substitution in `user-error' messages"
	  (assume (fboundp 'substitute-quotes))
	  (expect (user-error "`bar'") :to-throw 'user-error '("`bar'")))
	))



(provide 'test-substitute-quotes)
;;; test-substitute-quotes.el ends here
