;;; buttercup-examples.el --- Exercises the reporters  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Ola Nilsson

;; Author: Ola Nilsson <ola.nilsson@gmail.com>
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

;; The tests in this file are not meant to test the buttercup test
;; framework, but to be input data for reporter tests.

;;; Code:

(require 'buttercup)

(describe "A simple suite with"
  (it "one passing test" (expect 1 :to-equal 1))
  (it "one failing test" (expect 1 :to-equal 2))
  (it "one pending test")
  (xit "another pending test"))

(describe "An empty suite")

(provide 'buttercup-examples)
;;; buttercup-examples.el ends here

;; Local Variables:
;; indent-tabs-mode: nil
;; sentence-end-double-space: nil
;; End:
