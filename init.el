;; The value of this variable is the number of bytes of storage that must be  -*- lexical-binding: t; -*-
;; allocated for Lisp objects after one garbage collection in order to
;; trigger another garbage collection.
(setq gc-cons-threshold (* 800000 2))

(defvar dired-kill-when-opening-new-dired-buffer t) ; Kill the current buffer when selecting a new directory.
(setq history-length 25)                            ; Set the length of the command history.
(savehist-mode t)                                   ; Save minibuffer history.
(setq undo-no-redo t)                               ; Undo.
(column-number-mode t)                              ; Display the column number in the mode line.
(setq auto-save-default nil)                        ; Disable automatic saving of buffers.
(setq create-lockfiles nil)                         ; Prevent the creation of lock files when editing.
(setq make-backup-files nil)                        ; Disable creation of backup files.
(defvar pixel-scroll-precision-mode t)              ; Enable precise pixel scrolling.
(defvar pixel-scroll-precision-use-momentum nil)    ; Disable momentum scrolling for pixel precision.
(setq ring-bell-function 'ignore)                   ; Disable the audible bell.
(defvar warning-minimum-level :emergency)           ; Set the minimum level of warnings to display.
(setq use-short-answers t)                          ; Use short answers in prompts for quicker responses (y instead of yes).
(defvar duplicate-line-final-position 1)            ; Specifies where to move point after duplicating the line.
(defvar tags-revert-without-query t)                ; Don't prompt me to load tags.
;; Replace the standard text representation of various identifiers/symbols.
(global-prettify-symbols-mode t)
(defvar gdb-many-windows 1)                         ; gdb many windows layout.
(defvar gdb-show-main 1)                            ; Showing the source for the main function of the program you are debugging.
(defvar gud-highlight-current-line t)               ; GUD will visually emphasize the line being executed.
(recentf-mode 1)                                    ; Enable tracking of recently opened files.
(savehist-mode 1)                                   ; Enable saving of command history.
(save-place-mode 1)                                 ; Enable saving the place in files for easier return.
(winner-mode 1)                                     ; Enable winner mode to easily undo window configuration changes.
(epa-file-enable)                                   ; Encrypting and Decrypting gpg Files
;; Cache passphrase for symmetric encryption.
(defvar epa-file-cache-passphrase-for-symmetric-encryption t)
(xterm-mouse-mode 1)                                ; Enable mouse support in terminal mode.
(which-key-mode 1)                                  ; Enable which key mode.
(setq isearch-lazy-count t)                         ; Enable lazy counting to show current match information.
(setq lazy-count-prefix-format "(%s/%s) ")          ; Format for displaying current match count.
(setq lazy-count-suffix-format nil)                 ; Disable suffix formatting for match count.
(setq search-whitespace-regexp ".*?")               ; Allow searching across whitespace.
(setq help-at-pt-display-when-idle t)               ; Display messages when idle, without prompting
(setq tags-revert-without-query 1)                  ; Auto reload TAGS

(global-completion-preview-mode 1)
(setq completion-styles '(basic flex)
      completion-auto-help 'visible ;; Display *Completions* upon first request
      completions-format 'one-column ;; Use only one column
      completions-sort 'historical ;; Order based on minibuffer history
      completions-max-height 15) ;; Limit completions to 15 (completions start at line 5)
(defvar completions-ignore-case t)

;; Set calendar
(defvar calendar-latitude 49.5137)
(defvar calendar-longitude 8.4176)
(defvar calendar-location-name "Ludwigshafen")
;; My birthday
(setq holiday-other-holidays '((holiday-fixed 5 22 "Compleanno")))
;; Time 24hr format
(require 'time)
;;  Show current time in the modeline
(display-time-mode 1)
(defvar display-time-format nil)
(defvar display-time-24hr-format 1)

(show-paren-mode 1)                                 ; Matching pairs of parentheses.
;;(load-theme 'tango-dark t)                        ; Load tango-dark theme.
(when (eq custom-enabled-themes nil)
  (global-hl-line-mode 1))                          ; Enable highlight of the current line if theme is nil.
(global-auto-revert-mode 1)                         ; Enable global auto-revert mode to keep buffers up to date with their corresponding files.

(defvar sgml-validate-command "tidy")

;; Activate modes in debug
(defun nullzeiger/gdb-mode-customizations ()
  "Custom settings to apply when entering gdb-mode."
  (when (derived-mode-p 'gud-mode)
    (tool-bar-mode 1)
    (menu-bar-mode 1)
    (gud-tooltip-mode 1)))

;; Kill all buffers
(defun nullzeiger/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; Formatting C style using indent
(defun nullzeiger/indent-format ()
  "Formatting c file using indent."
  (interactive)
  (shell-command-to-string
   (concat
    "indent " (buffer-file-name)))
  (revert-buffer :ignore-auto :noconfirm))

;; Countdown Timer.
(defvar nullzeiger/countdown--timer nil
  "Variable to store the reference to the active countdown timer.")

(defun nullzeiger/countdown-timer (seconds)
  "Start a countdown timer for SECONDS seconds.
Updates the minibuffer every second and shows a message when finished."
  (interactive "nEnter countdown seconds: ")

  ;; If there's an existing timer, cancel it first
  (when (timerp nullzeiger/countdown--timer)
    (cancel-timer nullzeiger/countdown--timer)
    (setq nullzeiger/countdown--timer nil))

  ;; Local variable to keep track of remaining time
  (let ((remaining seconds))
    ;; Create and store the timer
    (setq nullzeiger/countdown--timer
          (run-at-time
           0 1
           (lambda ()
             (if (> remaining 0)
                 (progn
                   (message "⏳ %d second%s remaining..." remaining (if (= remaining 1) "" "s"))
                   (setq remaining (1- remaining)))
               (message "✅ Time is up!")
               (cancel-timer nullzeiger/countdown--timer)
               (setq nullzeiger/countdown--timer nil)))))))

(global-set-key (kbd "C-c n") 'flymake-goto-next-error)
(global-set-key (kbd "C-c p") 'flymake-goto-prev-error)
(global-set-key (kbd "C-.") 'duplicate-line)
(defvar completion-preview-active-mode-map (make-sparse-keymap))
(keymap-set completion-preview-active-mode-map "M-n" 'completion-preview-next-candidate)
(keymap-set completion-preview-active-mode-map "M-p" 'completion-preview-prev-candidate)
(keymap-set completion-preview-active-mode-map "M-i" 'completion-preview-insert)

;; Hooks
(add-hook 'gud-mode-hook 'nullzeiger/gdb-mode-customizations)
(add-hook 'gud-gdb 'gud-tooltip-mode 'tool-bar-mode 'menu-bar-mode)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
;;(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)
(add-hook 'c-mode-hook 'electric-pair-mode)
(add-hook 'c-mode-hook 'etags-regen-mode)
(add-hook 'comint-mode-hook 'completion-preview-mode)
(remove-hook 'flymake-cc 'flymake-proc-legacy-flymake)

;; Set guile default scheme.
(defvar scheme-program-name "guile-3.0")

;; Set python default scheme.
(defvar python-shell-interpreter "python3")

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Template
(require 'tempo)
(defvar tempo-interactive t)

(tempo-define-template "gnu-c-main"
  '("#include <stdlib.h>" n
    "#include <stdio.h>" n
    n
    "int" n
    "main (int argc, char *argv[])" n
    "{" n
    >"puts (\"Hello, World!\");" n
    n
    >"return EXIT_SUCCESS;" n
    "}" n)
  "gnu-c-program"
  "Insert complete GNU-style C program skeleton")

(define-abbrev-table 'c-mode-abbrev-table
'(
  ("main" "" tempo-template-gnu-c-main 0)
 ))

;;(define-abbrev c-mode-abbrev-table "main" "" 'tempo-template-gnu-c-main)

(add-hook 'c-mode-hook
	  (lambda ()
            (local-set-key (kbd "C-c C-m") 'tempo-template-gnu-c-main)))

;; po-mode
(use-package po-mode
  :load-path "/usr/share/emacs/site-lisp/elpa-src/po-mode-0.21/"
  :config
  (setq auto-mode-alist
	(cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
  (autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t))

;; Newsticker
(require 'newsticker)
(setq newsticker-url-list
      '(("GNU Emacs News" "https://www.gnu.org/software/emacs/news.xml")
	("Hacker News" "https://news.ycombinator.com/rss")
	("Ars Technica" "https://feeds.arstechnica.com/arstechnica/index/")
	("Adnkronos" "https://www.adnkronos.com/RSS_PrimaPagina.xml")))


(setq newsticker-retrieval-interval 1800)  ;; every 30 minutes

(setq newsticker-dir "~/.emacs.d/newsticker/")

(defvar newsticker-treeview-list-hide-old-items t)
(defvar newsticker-treeview-item-mark-old-after-days 3)
(defvar newsticker-treeview-tree-max-level 3)
(defvar newsticker-download-images t)
(defvar newsticker-download-enclosures t)

;; gnus
(require 'gnus)

;; Sort thread.
(setq gnus-thread-sort-functions
      '((not
	 gnus-thread-sort-by-date)
	gnus-thread-sort-by-number))

;; Personal Information.
(setq user-mail-address "ivan.guerreschi.dev@gmail.com"
      user-full-name "Ivan Guerreschi"
      user-login-name "ivan.guerreschi.dev")

;; Set directory.
(defvar message-directory "~/.emacs.d/mail/")       ; Directory used by many mailish things.
(setq gnus-directory "~/.emacs.d/news/")            ; Gnus storage file and directory.
(defvar gnus-use-dribble-file nil)                  ; Gnus won’t create and maintain a dribble buffer.

;; Send email through SMTP.
(defvar message-send-mail-function 'smtpmail-send-it)
(defvar smtpmail-smtp-server "smtp.gmail.com")
(defvar smtpmail-smtp-service 465)
(defvar smtpmail-stream-type 'tls)
(defvar gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;; read news from Gwene with Gnus.
(setq gnus-select-method '(nntp "news.gwene.org"))

;; GMAIL.
(add-to-list 'gnus-secondary-select-methods
	     '(nnimap "gmail"
		      (nnimap-address "imap.gmail.com")
		      (nnimap-server-port "imaps")
		      (nnimap-stream tls)
		      (nnir-search-engine imap)
		      (nnmail-expiry-target "nnimap+home:[Gmail]/Trash")
                      (nnmail-expiry-wait 'immediate)))

;; Auto Save
(setq gnus-use-dribble-file t)
(defvar gnus-always-read-dribble-file t)

;; Hide read email
(defvar gnus-summary-auto-hide t)
