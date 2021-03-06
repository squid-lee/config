(prefer-coding-system 'utf-8)

;; If proxying for packages is required and not set at the system level
;; (setq url-proxy-services
;;       '(("no_proxy" . "regex")
;;         ("http" . "regex")
;;         ("https" . "regex")))

;; A builtin of url-http for caching basicauth credentials
;; (setq url-http-proxy-basic-auth-storage
;; '(("proxy-name" ("Username: " . (base64-encode-string "LOGIN:PASSWORD"))))

;; For package management
(setq package-archives '(("org" . "http://orgmode.org/elpa/") ; Org-mode's repository
                         ("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'package)
(package-initialize)
(package-refresh-contents)
;; (unless (package-installed-p 'use-package)
;;   (package-install 'use-package nil))
(require 'use-package)

(defalias 'plp 'package-list-packages)

;; Keywords: Splitting horizontal vertical frame
;; (setq split-height-threshold nil)
;; (setq split-weight-threshold 0)

;; 2 spaces tabs
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset tab-width)
(setq standard-indent 2)
(setq indent-line-function 'insert-tab)

;; Syntax highlighting
(global-font-lock-mode t)

;; Don't truncate lines in any windows.
(setq truncate-partial-width-windows nil)

;; Global shortcut keys for compiling and running programs.
(setq compile-command "make -j")
(global-set-key [f6] 'compile)
(setq compilation-scroll-output "first-error")
(setq compilation-read-command nil) ; Compilation doesn't prompt for compile command, just does it

;; General niceties for getting UI out of the way
(tool-bar-mode -1) ; Has to be 1
(menu-bar-mode 0); Has to be 0
(set-scroll-bar-mode nil)

(setq inhibit-startup-screen t)
(setq initial-scratch-message 'nil)

;; (setq desktop-custom-folder "~/.emacs.d/desktop/")
;; (setq desktop-path '(desktop-custom-folder))
;; (unless (file-exists-p desktop-custom-folder)
;;   (make-directory desktop-custom-folder))
(desktop-save-mode t)

;; stop forcing me to spell out "yes"
(fset 'yes-or-no-p 'y-or-n-p)

;; Sets a nice default font, at a decent size (for 1920x1080 at 22")
(set-face-attribute 'default nil
                    :family "DejaVu Sans Mono" ;; Inconsolata-8 works pretty well for windows, with no height set
                    :height 90
                    :weight 'normal
                    :width 'normal)

(server-start)

;; Repeating C-SPC after C-u C-SPC will continue to pop marks from the
;  mark ring
(setq set-mark-command-repeat-pop 't)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; General rebinding
(global-set-key (kbd "M-*") 'pop-tag-mark)

(global-set-key (kbd "C-c #") 'server-edit)

(global-set-key (kbd "M-k") 'kill-sexp)

(global-set-key (kbd "C-x K") 'bury-buffer)

(global-set-key (kbd "M-H") 'windmove-left)
(global-set-key (kbd "M-L") 'windmove-right)
(global-set-key (kbd "M-K") 'windmove-up)
(global-set-key (kbd "M-J") 'windmove-down)

(global-set-key (kbd "M-g g") 'move-to-column)

;; This will make C-x r t actually insert the rectangle as a prefix
;; rather than just trashing the stuff it's prefixing if the rect
;; is too long
(global-set-key (kbd "C-x r t") 'string-insert-rectangle)

(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-C-h") 'backward-kill-word)

(global-set-key (kbd "C-S-k") 'kill-whole-line)

(global-set-key (kbd "C-^") 'delete-blank-lines)

(defun switch-to-scratch-buffer ()
  (interactive)
  (switch-to-buffer "*scratch*"))
(global-set-key (kbd "<F1> s") 'switch-to-scratch-buffer)

(global-set-key (kbd "C-x 4 k") 'kill-or-bury-other-buffer)

(defun insert-file-name-or-buffer-name ()
  (interactive)
  (insert (if buffer-file-name
              (file-name-base)
            (buffer-name))))
(global-set-key (kbd "C-x i") 'insert-file-name-or-buffer-name)

(defun just-zero-spaces ()
  (interactive)
  (just-one-space 0))

(global-set-key (kbd "M-S-SPC") 'just-zero-spaces)

(global-set-key (kbd "<XF86Calculator>") 'calc)

(global-set-key (kbd "C-x TAB") 'other-frame)

;; Unbound Keys
;; find-file-readonly, decided I actually like this
;;(global-unset-key (kbd "C-x C-r"))
;; Find alternate file, never helpful
(global-unset-key (kbd "C-x C-v"))
;; Suspend Frame, never helpful
(global-unset-key (kbd "C-z"))
;; Backward delete paragraph, never helpful
(global-unset-key (kbd "C-x DEL"))
;; Don't remove the ability to quit, but makes it a lot harder to accidentally quit
(global-unset-key (kbd "C-x C-c"))

;; Enabled functions
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'suspend-frame 'disabled t)
(put 'set-goal-column 'disabled nil)
(put 'erase-buffer 'disabled nil)


(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config (progn
            ;; Taken from http://www.emacswiki.org/emacs/IbufferMode#toc12
            ;; Use human readable Size column instead of original one
            (define-ibuffer-column size-h
              (:name "Size");; :inline t)
              (cond
               ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
               ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
               ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
               (t (format "%8d" (buffer-size)))))

            ;; Modify the default ibuffer-formats
            (setq ibuffer-formats
                  '((mark modified read-only " "
                          (name 18 18 :left :elide)
                          " "
                          (size-h 9 -1 :right)
                          " "
                          (mode 16 16 :left :elide)
                          " "
                          filename-and-process)))

            (defun ibuffer-quit-window-disable-filters ()
              (interactive)
              (ibuffer-filter-disable)
              (quit-window))

            (define-key ibuffer-mode-map (kbd "q") 'ibuffer-quit-window-disable-filters)))

(use-package magit
  :ensure t
  :bind ("C-x m" . magit-status)
  :config (progn
            (define-key magit-mode-map (kbd "M-H") 'windmove-left)
            (setq magit-push-always-verify nil)
            (setq magit-last-seen-setup-instructions "1.4.0")))

(use-package magit-filenotify
  :ensure t)

;; If you need to set an ssh-agent (keywords ssh agent git gui askpass)
;; (use-package ssh-agency ;; needs configuring

(setq vc-follow-symlinks 't)

(use-package git-timemachine
  :ensure t)

;; TODO, investigate this package for other bits n bobs
(use-package rectangle-utils
  :ensure t
  :bind ("C-x r e" . extend-rectangle-to-end))

(defun kill-or-bury-other-buffer ()
  (interactive)
  (save-selected-window
    (other-window 1)
    (if buffer-file-name
        (bury-buffer)
      (kill-buffer))))


; parenthesis matching
(show-paren-mode 't)

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files."))

(global-set-key [C-f5] 'revert-all-buffers)

;; These are all for the M-# binding to flip case of next char
(defun char-upcasep (c)
  (eq c (upcase c)))

(defun char-downcasep (c)
  (eq c (downcase c)))

(defun downcase-next-letter ()
  "Toggles the case of the next letter, then moves the point forward one character"
  (interactive)
  (let ((p (point)))
    (progn
      (downcase-region p (1+ p))
      (forward-char))))

(defun toggle-case-next-letter ()
  "Toggles the case of the next letter, then moves the point forward one character"
  (interactive)
  (let* ((p (point))
        (upcased (char-upcasep (char-after)))
        (f (if upcased 'downcase-region 'upcase-region)))
    (progn
      (funcall f p (1+ p))
      (forward-char))))

(global-set-key (kbd "M-#") 'toggle-case-next-letter)

(setq calendar-set-date-style 'iso)

;; Auto set some registers for faster access to commonly used files
(set-register ?A '(file . "~/.aliases"))
(set-register ?B '(file . "~/.bin/bin"))
(set-register ?D (cons 'file (if (member system-type '(windows-nt cygwin))
                                 "~/../../Downloads" ;; ~ is app data
                               "~/Downloads")))
(set-register ?E  (cons 'file user-init-file)) ;; has to be this form so the user-init-file is eval'd
(set-register ?G '(file . "~/g/"))
(set-register ?N '(file . "~/.org/Reference.org"))
(set-register ?S '(file . "~/Scripts/generalScripts/"))
(set-register ?T '(file . "~/.org/TODO.org"))
(set-register ?U '(file . "~/.org/unix-toolkit.org"))
(set-register ?W '(file . "~/.org/wishlist.org"))
(set-register ?X '(file . "~/.xmonad/xmonad.hs"))
(set-register ?Z '(file . "~/.zshrc"))


(global-set-key (kbd "M-{") (lambda () (interactive) (point-to-register ?P)))
(global-set-key (kbd "M-}") (lambda () (interactive) (jump-to-register ?P)))

(use-package flycheck
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error)))

(defun add-new-import (new-import)
  (interactive
   (list (read-from-minibuffer "Module Name: " nil nil nil 'haskell-import-history)))
  (save-excursion
    (progn
      (goto-char 0)
      (re-search-forward "^import " nil nil)
      (let ((processed-import (s-chop-prefix "import " (s-trim new-import))))
        (insert processed-import)
        (insert "\nimport ")
        (message (concat "Imported " process-import))
        (haskell-sort-imports)))))

(defun insert-undefined ()
  (interactive)
  (insert "undefined"))

;; Haskell Mode
(use-package haskell-mode
  :ensure t
  :bind (:map haskell-mode-map
              ("C-c i" . add-new-import)
              ("C-c C-u" . insert-undefined)
              ("M-s h" . hoogle)
              ;; ("M-." . ripgrep-haskell-definition)
              )
  :config (progn
            (define-abbrev haskell-mode-abbrev-table "improt" "import")
            (define-abbrev haskell-mode-abbrev-table "Bytestring" "ByteString")
            (define-abbrev haskell-mode-abbrev-table "reutnr" "return")
            (define-abbrev haskell-mode-abbrev-table "reutrn" "return")))

;; Runs like garbage most of the time
;; (use-package intero
;;   :ensure t
;;   :config (add-hook 'haskell-mode-hook 'intero-mode))

(use-package haskell-snippets
  :ensure t)

;; (use-package ebal
;;   :ensure t
;;   :config
;;   (add-hook 'haskell-mode-hook 'ebal-mode)
;;   (setq ebal-operation-mode 'stack))

(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

;; Necessary for sqldeveloper wrapper
(setenv "TNS_ADMIN" "/usr/lib/oracle/12.2/client64/network/admin")

;; Needed for sbt to be found by emacs, because emacs maintains a
;; different $PATH to $USER, and because ensime reads the path
;; variable
(setq exec-path (append exec-path (list "~/.bin/bin")))
(setenv "PATH" (concat "/home/joseph/.bin/bin:" (getenv "PATH")))

(use-package scala-mode2
  :ensure t)
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
;(add-hook 'ensime-source-buffer-saved-hook 'ensime-format-source)

(use-package ensime
  :ensure t
  :load-path "/home/joseph/g/ensime-emacs/"
  :bind ("M-*" . ensime-pop-find-definition-stack)
  :config (progn
          (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
          ;; Necessary for ensime
          (setq ensime-startup-notification nil)
          (setenv "JDK_HOME" "/usr/lib/jvm/java-8-openjdk-amd64")
          (setenv "JAVA_HOME" "/usr/lib/jvm/java-8-openjdk-amd64/jre")))

(use-package rainbow-delimiters
  :ensure t
  :config (progn
            ;; Rainbow delimiters
            (add-hook 'prog-mode-hook 'rainbow-delimiters-mode-enable)))

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp
                 isearch-string
               (regexp-quote isearch-string))))))

(defun dired-up-directory-this-window ()
  "Go up a directory, in this window"
  (interactive)
  (dired-up-directory nil))

(use-package dired
  :config (progn
            (define-key dired-mode-map (kbd "b") 'dired-up-directory-this-window)
            (define-key dired-mode-map (kbd "c") 'find-file)
            ;; Iso timestyle may screw things up in windows (keywords ls time format)
            (setq dired-listing-switches "-Alh --time-style=long-iso")))

;; Expand stuff using M-/. tbh it sucks, but nothing better seems to exist
(global-set-key (kbd "M-/") 'dabbrev-expand)
(setq dabbrev-case-replace nil)

;; Means that M-a and M-e recognise sentences with a single space following full stop.
(setq sentence-end-double-space nil)

(defadvice jump-to-register (around jump-to-buffer-maybe
                                    (register &optional delete)
                                    activate compile)
  (let ((r (get-register register)))
    (if (bufferp r)
        (switch-to-buffer r)
      ad-do-it) ))

(defun buffer-to-register (buf reg)
  (interactive "bBuffer: \ncRegister: ")
  (set-register reg (get-buffer buf)) )

(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(setq save-abbrevs t)

(if (file-exists-p abbrev-file-name)
        (quietly-read-abbrev-file))

(add-hook 'tex-mode-hook
  (lambda ()
    (set (make-local-variable 'compile-command)
         (concat "pdflatex \\nonstopmode\\input " (buffer-file-name)))))

(setq
  backup-by-copying t      ; don't clobber symlinks
  backup-directory-alist '(("." . "~/.emacs.d/backups"))    ; don't litter my fs tree
  delete-old-versions :keep-all
  version-control t
  auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list" t)))

; Sets middle click paste to paste at point rather than click location
(setq mouse-yank-at-point t)

(defun paste-from-x ()
  (interactive)
  (mouse-yank-primary nil))

(global-set-key (kbd "S-<insert>") 'paste-from-x)

;; (use-package ess
;;   :ensure t
;;   :config (progn
;;             (define-key ess-mode-map (kbd "C-M-H") 'backward-kill-word)
;;             ;; Ess Mode doesn't extend prog-mode
;;             (add-hook 'ess-mode-hook 'rainbow-delimiters-mode-enable)
;;             (setq inferior-julia-program-name "/usr/bin/julia")))

;; (require 'ess-site)
;; (use-package ess-smart-underscore
;;   :ensure t)



;; Display column number as well as line number
(setq column-number-mode t)

;; Disable the bell
(setq visible-bell 't)

;; Sets the default browser
(setq browse-url-browser-function 'browse-url-generic)
      ;; browse-url-generic-program "/usr/bin/firefox")

(use-package eshell
   :bind ("C-c e" . eshell))

(defun open-register-in-background (register-name)
  (save-window-excursion
    (jump-to-register register-name)
    (current-buffer)))

(defun jump-to-register-other-window (register-name)
  "Open a register in the other window if file"
  ;; Should also display register contents if register is text
  ;; jump-to-register allows it to fail silently if non-legit
  ;; register is passed in

  (interactive "cJump to register: \n")
  (switch-to-buffer-other-window (open-register-in-background register-name)))

(global-set-key (kbd "C-x 4 j") 'jump-to-register-other-window)

(global-set-key (kbd "C-z") 'repeat)
(global-set-key (kbd "C-`") 'repeat)
(global-set-key (kbd "M-C-`") 'repeat-complex-command)



;; Stupid name, gives a decent list processing library
(use-package dash
  :ensure t)

(use-package s
  :ensure t)

(defun s-upper-snake-case (s)
  (s-upcase (s-snake-case s)))

(defun s-lower-snake-case (s)
  (s-snake-case s))

(defun s-camel-case (s)
  (s-lower-camel-case s))

(defalias 's-words 's-split-words)

; (load-file "~/.emacs.d/testing/chop-s-ui.el")

;; Whitespaces now match literally again in C-s
(setq search-whitespace-regexp nil)

(setq read-buffer-completion-ignore-case 't)

(defun prompt-for-insert ()
  (interactive)
  (insert (read-string "Insert: ")))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c m c" . mc/edit-lines)
         ("C-c m a" . mc/mark-all-words-like-this)
         ("C-c m n" . mc/insert-numbers)
         ("C-c m q" . prompt-for-insert)

         ("C-c C-m c" . mc/edit-lines)
         ("C-c C-m a" . mc/mark-all-words-like-this)
         ("C-c C-m n" . mc/insert-numbers)
         ("C-c C-m q" . prompt-for-insert)

         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))

(use-package mc-extras
  :ensure t
  :bind (("C-c m d" . mc/remove-current-cursor)
         ("C-c m D" . mc/remove-duplicated-cursors)
         ("C-c m M-f" . mc/compare-chars-forward)
         ("C-c m M-b" . mc/compare-chars-backward)

         ("C-c C-m d" . mc/remove-current-cursor)
         ("C-c C-m D" . mc/remove-duplicated-cursors)
         ("C-c C-m M-f" . mc/compare-chars-forward)
         ("C-c C-m M-b" . mc/compare-chars-backward)))

(use-package iy-go-to-char
  :ensure t
  :bind (("C-c f" . iy-go-to-char)
         ("C-c b" . iy-go-to-char-backward))
  :config (add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos))

(use-package avy-zap
  :ensure t
  :config (progn
            (defun my-avy-zap-to-char-dwim (&optional prefix)
              (interactive "P")
              (if prefix
                  (avy-zap-to-char)
                (call-interactively 'zap-to-char)))
            (defun my-avy-zap-up-to-char-dwim (&optional prefix)
              (interactive "P")
              (if prefix
                  (avy-zap-up-to-char)
                (call-interactively 'zap-up-to-char))))
  :bind (("M-z" . my-avy-zap-to-char-dwim)
         ("C-Z" . my-avy-zap-up-to-char-dwim)))

(use-package ace-window
  :ensure t
  :bind ("C-x o" . ace-window)
  :config (progn
            (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
            (setq aw-scope 'frame)
            (setq aw-background nil)))

(defun avy-copy (char)
  (interactive "cchar: \n")
  (let ((word (save-excursion
                (progn
                  (avy-goto-subword-1 char)
                  (word-at-point)))))
    (insert word)))

(defun avy-subword-or-char (char)
  (interactive "cchar: \n")
  (and (string-equal
      (avy-goto-subword-1 char)
      "zero candidates")
     (avy-goto-char char)))

(use-package avy
  :ensure t
  :pin melpa
  :bind (("C-:" . avy-subword-or-char)
         ("C-;" . avy-copy))
  :config (setq avy-style 'at-full
                avy-background 't))

(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))

(defalias 'rw 'rotate-windows)

(setq frame-title-format "(emacs %b)")

;; Built in package
(use-package uniquify)

(use-package js2-mode
  :ensure t
  :config (setq j2-basic-offset 2))

(setq js-indent-level 2)


;; (use-package moz
;;   :ensure t
;;   :config (progn
;;             (add-hook 'javascript-mode-hook 'javascript-moz-setup)
;;             (defun javascript-moz-setup ()
;;               (moz-minor-mode 't))))

(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . rmd-mode))

(use-package expand-region
  :ensure t
  :bind ("M-@" . er/expand-region))

(defalias 'rb 'revert-buffer)

(defalias 'insert-from-url 'url-insert-file-contents)

(setq require-final-newline t)

(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(global-set-key (kbd "C-c =") 'my-increment-number-decimal)
(global-set-key (kbd "C-c C-=") 'my-increment-number-decimal)
(global-set-key (kbd "C-c -") (lambda() (interactive) (my-increment-number-decimal -1)))
(global-set-key (kbd "C-c C--") (lambda() (interactive) (my-increment-number-decimal -1)))

(defun eval-and-replace ()
  (interactive)
  (let ((value (eval (preceding-sexp))))
    (kill-sexp -1)
    (insert (format "%s" value))))

(global-set-key (kbd "C-c C-x C-e") 'eval-and-replace)

(use-package projectile
  :ensure t
  :config (progn
            (projectile-global-mode)
            (setq projectile-enable-caching t)
            (setq projectile-completion-system 'default)
            (setq projectile-tags-command (concat "/usr/bin/" projectile-tags-command))))

(use-package projectile-ripgrep
  :ensure t
  :bind (:map projectile-mode-map
              ("C-c p s s" . projectile-ripgrep)
         :map ripgrip-search-mode-map
              ("f" . compile-goto-error)))

;; Commands which move by line (e.g. C-a, C-e etc) move by 'real'
;; lines rather than visual lines so wrapped lines will still count as
;; a single line even when displayed as one line
(setq line-move-visual nil)

(use-package which-key
  :init (progn
          (which-key-setup-side-window-bottom)
          (setq which-key-idle-delay 0.5)
          (which-key-mode))
  :ensure t)

(use-package xkcd
  :ensure t)

(use-package visual-regexp
  :ensure t
  :bind (("C-%" . vr/query-replace)
         ("C-c m r" . vr/mc-mark)))

(use-package smex
  :ensure t
  :config (global-set-key (kbd "M-x") 'smex)
          (global-set-key (kbd "M-X") 'smex-major-mode-commands)
          ;; This is your old M-x.
          (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(defun make-temp-buffer ()
  (interactive)
  (switch-to-buffer (make-temp-name "scratch")))

(defun make-temp-buffer-other-window ()
  (interactive)
  (switch-to-buffer-other-window (make-temp-name "scratch")))

(global-set-key (kbd "C-x p") 'make-temp-buffer)
(global-set-key (kbd "C-x 4 p") 'make-temp-buffer-other-window)


(defun make-temp-org-buffer ()
  (interactive)
  (progn
    (switch-to-buffer (make-temp-name "scratch"))
    (cd "~/.org")
    (org-mode)))

(use-package ob-prolog
  :ensure t)

(use-package org
  :ensure t
  :bind (("C-x C-p" . make-temp-org-buffer)
         ("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c t" . org-capture))
  :config (progn
            (setq org-enforce-todo-dependencies 't)
            (setq org-catch-invisible-edits 'show)
            (setq org-src-fontify-natively 't)
            (setq org-src-tab-acts-natively 't)
            (setq org-html-postamble nil)
            (setq org-use-speed-commands 't)
            (setq org-export-with-sub-superscripts nil)
            (setq org-directory "~/.org/")

            ;; Export wrangling
            (setq org-export-with-section-numbers nil)
            (setq org-export-with-toc nil)

            (setq org-todo-keywords '("IDEA" "TODO" "DOING" "BLOCKED" "BURNER" "DONE"))

            (define-key org-mode-map (kbd "RET") 'org-return-indent)

            (org-babel-do-load-languages
             'org-babel-load-languages
             '((dot . t)
               (emacs-lisp . t)
               (haskell . t)
               (php . t)
               (prolog . t)
               (R . t)
               (sh . t))))
  :pin org)

; Built in package
(use-package dired-x)

(use-package yasnippet
  :ensure t
  :defer t
  :commands yas-minor-mode
  :config (progn
            (define-key yas-minor-mode-map (kbd "M-'") 'yas-expand)
            (add-hook 'emacs-lisp-mode-hook 'yas-minor-mode-on)
            (add-hook 'haskell-mode-hook 'yas-minor-mode-on)
            (add-hook 'org-mode-hook 'yas-minor-mode-on)
            (add-hook 'python-mode-hook 'yas-minor-mode-on)
            (add-hook 'R-mode-hook 'yas-minor-mode-on)
            (add-hook 'ruby-mode-hook 'yas-minor-mode-on)
            (add-hook 'rust-mode-hook 'yas-minor-mode-on)
            (add-hook 'scala-mode-hook 'yas-minor-mode-on)
            (yas-reload-all)
            (yas-global-mode)))

(use-package rust-mode
  :ensure t
  :config (setq rust-format-on-save t))

(use-package toml-mode
  :ensure t)

(use-package racer
  :ensure t
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)

  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (setq company-tooltip-align-annotations t))

(defun insert-python-debugger-break ()
  (interacrtive)
  (back-to-indentation)
  (insert "import pdb; pdb.set_trace()")
  (newline))

(use-package python
  :defer t
  :bind ("C-c C-d" . insert-python-debugger-break)
  :config (progn
            (setq python-indent-offset 2)
            (define-abbrev python-mode-abbrev-table "improt" "import")))

(setq enable-recursive-minibuffers 't)

(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line))

(global-set-key (kbd "C-S-o") 'open-next-line)

(define-key comint-mode-map (kbd "C-a") 'comint-bol)
(define-key comint-mode-map (kbd "M-m") 'comint-bol)

(setq message-log-max 't)

(setq-default ispell-program-name "aspell")

(use-package dockerfile-mode
  :ensure t)

(use-package transpose-frame
  :ensure t)

; More goodness from Magnars Sveen
(use-package change-inner
  :ensure t
  :bind (("M-i" . change-inner)
         ("M-o" . change-outer)))

(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (if (and (not (file-exists-p dir))
               (y-or-n-p (format "Create directory: %s" dir)))
          (make-directory dir 't)))))

(use-package markdown-mode
  :ensure t)

(use-package markdown-mode+
  :ensure t)


(define-generic-mode 'strace-mode
  '("+++")                 ;; treat +++ as a comment - it sort of is
  '("accept"              "accept4"                 "access"
    "acct"                "add_key"                 "adjtimex"
    "afs_syscall"         "alarm"                   "alloc_hugepages"
    "bdflush"             "bind"                    "brk"
    "cacheflush"          "capget"                  "capset"
    "cate"                "chdir"                   "chmod"
    "chown"               "chown32"                 "chroot"
    "clock_adjtime"       "clock_getres"            "clock_gettime"
    "clock_nanosleep"     "clock_settime"           "clone"
    "close"               "connect"                 "creat"
    "create_module"       "delete_module"           "dup"
    "dup2"                "dup3"                    "epoll_create"
    "epoll_create1"       "epoll_ctl"               "epoll_pwait"
    "epoll_wait"          "eventfd"                 "eventfd2"
    "execve"              "exit"                    "exit_group"
    "faccessat"           "fadvise64"               "fadvise64_64"
    "fallocate"           "fanotify_init"           "fanotify_mark"
    "fchdir"              "fchmod"                  "fchmodat"
    "fchown"              "fchown32"                "fchownat"
    "fcntl"               "fcntl64"                 "fdatasync"
    "fgetxattr"           "finit_module"            "flistxattr"
    "flock"               "fork"                    "free_hugepages"
    "fremovexattr"        "fsetxattr"               "fstat"
    "fstat64"             "fstatat64"               "fstatfs"
    "fstatfs64"           "fsync"                   "ftruncate"
    "ftruncate64"         "futex"                   "futimesat"
    "getcpu"              "getcwd"                  "getdents"
    "getdents64"          "getegid"                 "getegid32"
    "geteuid"             "geteuid32"               "getgid"
    "getgid32"            "getgroups"               "getgroups32"
    "getitimer"           "get_kernel_syms"         "get_mempolicy"
    "getpagesize"         "getpeername"             "getpgid"
    "getpgrp"             "getpid"                  "getppid"
    "getpriority"         "getresgid"               "getresgid32"
    "getresuid"           "getresuid32"             "getrlimit"
    "get_robust_list"     "getrusage"               "getsid"
    "getsockname"         "getsockopt"              "get_thread_area"
    "gettid"              "gettimeofday"            "getuid"
    "getuid32"            "getxattr"                "init_module"
    "inotify_add_watch"   "inotify_init"            "inotify_init1"
    "inotify_rm_watch"    "io_cancel"               "ioctl"
    "io_destroy"          "io_getevents"            "ioperm"
    "iopl"                "ioprio_get"              "ioprio_set"
    "io_setup"            "io_submit"               "ipc"
    "kcmp"                "kern_features"           "kexec_load"
    "keyctl"              "kill"                    "lchown"
    "lchown32"            "lgetxattr"               "link"
    "linkat"              "listen"                  "listxattr"
    "llistxattr"          "_llseek"                 "lookup_dcookie"
    "lremovexattr"        "lseek"                   "lsetxattr"
    "lstat"               "lstat64"                 "madvise"
    "madvise1"            "mbind"                   "migrate_pages"
    "mincore"             "mkdir"                   "mkdirat"
    "mknod"               "mknodat"                 "mlock"
    "mlockall"            "mmap"                    "mmap2"
    "modify_ldt"          "mount"                   "move_pages"
    "mprotect"            "mq_getsetattr"           "mq_notify"
    "mq_open"             "mq_timedreceive"         "mq_timedsend"
    "mq_unlink"           "mremap"                  "msgctl"
    "msgget"              "msgrcv"                  "msgsnd"
    "msync"               "munlock"                 "munlockall"
    "munmap"              "name_to_handle_at"       "nanosleep"
    "_newselect"          "nfsservctl"              "nice"
    "oldfstat"            "oldlstat"                "oldolduname"
    "oldstat"             "olduname"                "open"
    "openat"              "open_by_handle_at"       "pause"
    "pciconfig_iobase"    "pciconfig_read"          "pciconfig_write"
    "perfctr"             "perf_event_open"         "perfmonctl"
    "personality"         "pipe"                    "pipe2"
    "pivot_root"          "poll"                    "ppc_rtas"
    "ppoll"               "prctl"                   "pread64"
    "preadv"              "prlimit"                 "process_vm_readv"
    "process_vm_writev"   "pselect6"                "ptrace"
    "pwrite64"            "pwritev"                 "query_module"
    "quotactl"            "read"                    "readahead"
    "readdir"             "readlink"                "readlinkat"
    "readv"               "reboot"                  "recv"
    "recvfrom"            "recvmmsg"                "recvmsg"
    "remap_file_pages"    "removexattr"             "rename"
    "renameat"            "request_key"             "restart_syscall"
    "rity"                "rmdir"                   "rt_sigaction"
    "rt_sigpending"       "rt_sigprocmask"          "rt_sigqueueinfo"
    "rt_sigreturn"        "rt_sigsuspend"           "rt_sigtimedwait"
    "rt_tgsigqueueinfo"   "s390_runtime_instr"      "sched_getaffinity"
    "sched_getparam"      "sched_get_priority_max"  "sched_get_priority_min"
    "sched_getscheduler"  "sched_rr_get_interval"   "sched_setaffinity"
    "sched_setparam"      "sched_setscheduler"      "sched_yield"
    "select"              "semctl"                  "semget"
    "semop"               "semtimedop"              "send"
    "sendfile"            "sendfile64"              "sendmmsg"
    "sendmsg"             "sendto"                  "setdomainname"
    "setfsgid"            "setfsgid32"              "setfsuid"
    "setfsuid32"          "setgid"                  "setgid32"
    "setgroups"           "setgroups32"             "sethostname"
    "setitimer"           "set_mempolicy"           "setns"
    "setpgid"             "setpriority"             "setregid"
    "setregid32"          "setresgid"               "setresgid32"
    "setresuid"           "setresuid32"             "setreuid"
    "setreuid32"          "setrlimit"               "set_robust_list"
    "setsid"              "setsockopt"              "set_thread_area"
    "set_tid_address"     "settimeofday"            "setuid"
    "setuid32"            "setup"                   "setxattr"
    "sgetmask"            "shmat"                   "shmctl"
    "shmdt"               "shmget"                  "shutdown"
    "sigaction"           "sigaltstack"             "signal"
    "signalfd"            "signalfd4"               "sigpending"
    "sigprocmask"         "sigreturn"               "sigsuspend"
    "socket"              "socketcall"              "socketpair"
    "splice"              "spu_create"              "spu_run"
    "ssetmask"            "stat"                    "stat64"
    "statfs"              "statfs64"                "stime"
    "subpage_prot"        "swapoff"                 "swapon"
    "symlink"             "symlinkat"               "sync"
    "sync_file_range"     "sync_file_range2"        "syncfs"
    "syscall"             "_sysctl"                 "sysfs"
    "sysinfo"             "syslog"                  "tee"
    "tgkill"              "time"                    "timer_create"
    "timer_delete"        "timerfd_create"          "timerfd_gettime"
    "timerfd_settime"     "timer_getoverrun"        "timer_gettime"
    "timer_settime"       "times"                   "tkill"
    "truncate"            "truncate64"              "ugetrlimit"
    "umask"               "umount"                  "umount2"
    "uname"               "unlink"                  "unlinkat"
    "unshare"             "uselib"                  "ustat"
    "utime"               "utimensat"               "utimes"
    "utrap_install"       "vfork"                   "vhangup"
    "vm86"                "vm86old"                 "vmsplice"
    "wait4"               "waitid"                  "waitpid"
    "write"               "writev")
  '(("[A-Z_]+" . 'font-lock-constant-face)) ;operators & builtins
  '("\\.strace$") ; regex for files
  nil ; other functions to call
  "A dead simple mode for highlighting the result of an strace") ; doc string

(define-generic-mode 'xmodmap-mode
  '(?!)
  '("add" "clear" "keycode" "keysym" "pointer" "remove")
  nil
  '("[xX]modmap\\(rc\\)?\\'")
  nil
  "Simple mode for xmodmap files.")

(use-package undo-tree
  :ensure t
  :config (progn
            (global-undo-tree-mode)))

;; Required for emacs version < 24.4
(defun json-pretty-print-buffer ()
  (interactive)
  (let ((json-encoding-pretty-print t))
    (let ((json-string (json-encode (json-read-from-string (buffer-string))))
          (buf (current-buffer)))
      (with-current-buffer buf
        (erase-buffer)
        (insert json-string)))))

(defun json-pretty-print ()
  (interactive)
  (unless mark-active
    (error "No region selected."))
  (let ((begin (region-beginning))
        (end (region-end)))
    (kill-region begin end)
    (let ((json-encoding-pretty-print t))
      (insert (json-encode (json-read-from-string (current-kill 0)))))))

;; (use-package paredit
;;   :ensure t)

(defun char-name ()
  (interactive)
  (message
   (let ((chr (char-after (point))))
     (or (get-char-code-property chr 'name)
         (get-char-code-property chr 'old-name)))))

;; Query iff buffer is called *Messages*
(defun prevent-buffer-death ()
  (let ((b (buffer-name)))
    (or (not (string= b "*Messages*"))
        (y-or-n-p (concat "Really kill " b)))))

(add-to-list 'kill-buffer-query-functions 'prevent-buffer-death)

(defun kill-and-back-to-indentation ()
  (interactive)
  (progn
    (back-to-indentation)
    (kill-line)))

(global-set-key (kbd "C-M-k") 'kill-and-back-to-indentation)

(defun my-rectangle-yank (prefix)
  (interactive "P")
  (if prefix
      (insert (with-temp-buffer
                (yank-rectangle)
                (query-replace "
                " (read-string "Join rectangle with: "))
                (buffer-string)))
    (yank-rectangle)))

(setq-default abbrev-mode t)

(use-package hydra
  :ensure t)

(use-package go-mode
  :ensure t)

(use-package systemd
  :ensure t)

;; Check github for usage. Not yet enabled / configured
(use-package eno
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package puppet-mode
  :ensure t)

(use-package ag
  :ensure t)

(use-package crontab-mode
  :ensure t)

(use-package crappy-jsp-mode
  :ensure t)

(use-package browse-kill-ring
  :ensure t)

(use-package browse-kill-ring+
  :ensure t)

(use-package scad-mode
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org ob-prolog dot-mode ess-smart-underscore ess protobuf-mode which-key ag puppet-mode yaml-mode eno systemd go-mode hydra corral undo-tree markdown-mode+ markdown-mode change-inner transpose-frame dockerfile-mode ox-reveal coffee-mode visual-regexp xkcd guide-key projectile expand-region js2-mode ace-window avy-zap iy-go-to-char mc-extras multiple-cursors rainbow-delimiters ensime scala-mode2 zenburn-theme haskell-mode rectangle-utils git-timemachine magit use-package "use-package" "use-package" "use-package"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "dark violet"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "cyan2"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "MediumOrchid1"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "magenta")))))
