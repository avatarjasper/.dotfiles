(setq package-check-signature nil)


(setq frame-title-format "%b - %f")

;; Bootstrap package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; visual line mode standard
(global-visual-line-mode t)


(use-package modus-themes
  :ensure t)

(use-package zenburn-theme
  :ensure t
  ;; :config (load-theme 'zenburn t)
  )	


(use-package ef-themes
  :ensure t
  :config
  (mapc #'disable-theme
	custom-enabled-themes)
  (load-theme 'ef-arbutus t))

(require 'tramp)
(setq tramp-default-method "ssh")


(setq tramp-use-ssh-controlmaster-options nil)
(setq auth-sources '())

(setq bookmark-save-flag 1)


(require 'dired-x)

(use-package org
  :ensure t
  )

;; Which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))


;; (use-package avy
;;   :ensure t
;;   :bind
;;   ("C-;" . avy-goto-char)
;;   ("C-'" . avy-goto-char-2))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "wslview")

;; ORG MODE
(use-package org-super-agenda
  :ensure t
  :config
  (org-super-agenda-mode)
  )

;; (add-to-list 'load-path "~/.emacs.d/elpa/sqlite3-20251014.536")
;; (require 'sqlite3)


;; (use-package org-roam
;;   :ensure t
;;   :custom
;;   (org-roam-directory "~/org/roam/")
;;   :config
;;   (org-roam-db-autosync-mode))


;; org cache persistency
(setq org-element-cache-persistent nil)



;; Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-mode-list
	(remove 'vterm evil-collection-mode-list))
  (evil-collection-init))


(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :after evil-collection
  :config
  (global-evil-surround-mode 1))

(add-hook 'ediff-mode-hook 'evil-emacs-state)

;; ORG

(setq org-agenda-files
      (directory-files-recursively "~/org" "\\.org$"))
(setq org-log-done 'time)
(setq org-return-follows-link  t)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'org-indent-mode)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Task" entry (file "~/org/refile.org")
         "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:")
        ("n" "Note" entry (file "~/org/refile.org")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:")))



(setq org-hide-emphasis-markers t)


;; search all org files and up to 3 levels deep
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

;; show full path  tasks.org/Projects/My Project
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

;; create new headings on the fly when refiling
(setq org-refile-allow-creating-parent-nodes 'confirm)


(defun my/org-hide-done-entries-in-region (start end)
  (interactive "r")
  (org-map-entries #'org-fold-hide-subtree
                   "/+DONE" 'region 'archive 'comment))

(defun my/org-hide-done-entries-in-buffer ()
  (interactive)
  (org-map-entries #'org-fold-hide-subtree
                   "/+DONE" 'file 'archive 'comment))




(defun my/agenda-goto-narrow ()
  (interactive)
  (org-agenda-goto)
  (org-narrow-to-subtree))

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "C-<return>") 'my/agenda-goto-narrow))

(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "WAITING" "|" "DONE" "CANCELLED")))
(setq org-todo-keyword-faces
      '(("NEXT"    . (:foreground "blue"   :weight bold))
        ("WAITING" . (:foreground "orange" :weight bold))
        ("CANCELLED" . (:foreground "gray" :strike-through t))))



(use-package comment-tags
  :ensure t
  :hook (prog-mode . comment-tags-mode)
  :custom
  (comment-tags-keyword-faces
   '(("TODO"  . (:foreground "green"  :weight bold))
     ("FIXME" . (:foreground "red"    :weight bold))
     ("HACK"  . (:foreground "yellow" :weight bold))
     ("NOTE"  . (:foreground "blue"   :weight bold)))))




;;VERTICO

(use-package vertico
  :ensure t
  :config (vertico-mode))


(use-package vertico-quick
  :after vertico)

;; (use-package orderless
;;   :ensure t
;;   :custom (completion-styles '(orderless basic)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion)))))


;; CONSULT

(use-package consult
  :ensure t
  :bind (("C-c M-x" . consult-mode-command)
         ("C-c h"   . consult-history)
         ("C-c k"   . consult-kmacro)
         ("C-c m"   . consult-man)
         ("C-c f"   . consult-fd)
         ("C-c i"   . consult-info)
         ([remap Info-search] . consult-info)

         ("C-x M-:" . consult-complex-command)
         ("C-x b"   . consult-buffer)
         ("C-x 4 b"  . consult-buffer-other-window)
         ("C-x 5 b"  . consult-buffer-other-frame)
         ("C-x r b"  . consult-bookmark)
         ("C-x p b"  . consult-project-buffer)

         ("M-y"     . consult-yank-pop)

         ("M-g e"   . consult-compile-error)
         ("M-g f"   . consult-flymake)
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o"   . consult-outline)
         ("M-g m"   . consult-mark)
         ("M-g k"   . consult-global-mark)
         ("M-g i"   . consult-imenu)
         ("M-g I"   . consult-imenu-multi)

         ("M-s d"   . consult-find)
         ("M-s D"   . consult-locate)
         ("M-s g"   . consult-grep)
         ("M-s G"   . consult-git-grep)
         ("M-s r"   . consult-ripgrep)
         ("M-s l"   . consult-line)
         ("M-s L"   . consult-line-multi)
         ("M-s k"   . consult-keep-lines)
         ("M-s u"   . consult-focus-lines)

         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)

         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))
  :hook
  (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Reasonable async tuning
  (setq consult-async-input-debounce 0.2
        consult-async-input-throttle 0.4
        consult-narrow-key "<")

  ;; Prefill consult-line from symbol/region if available
  (consult-customize
   consult-line
   :initial (thing-at-point 'symbol)

   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key "M-."))



;; shows useful info next to completions
(use-package marginalia
  :ensure t
  :config (marginalia-mode))

(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm)
  :config
  (evil-set-initial-state 'vterm-mode 'emacs)
  (setq vterm-term-environment-variable "xterm-256color"))


(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :config
  (global-corfu-mode 1)
  (evil-make-overriding-map corfu-map))


(use-package cape
  :ensure t
  :bind (("C-c p" . cape-prefix-map)
         ("M-/" . completion-at-point))
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history))


(use-package wgrep
  :ensure t)

;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/elpa-src/notmuch-0.35")
;; (require 'notmuch)

;; (setq notmuch-search-oldest-first nil
;;       mail-user-agent 'notmuch-user-agent)

;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-stream-type 'starttls
;;       user-mail-address "jasper.geijsberts@gmail.com"
;;       user-full-name "Jasper Geijsberts"
;;       auth-sources '("~/.authinfo.gpg"))

;; (add-hook 'notmuch-show-mode-hook 'evil-emacs-state)
;; (add-hook 'notmuch-search-mode-hook 'evil-emacs-state)
;; (add-hook 'notmuch-hello-mode-hook 'evil-emacs-state)


(global-set-key (kbd "C-c o") 
		(lambda () (interactive) (find-file "~/org/todo.org")))
(global-set-key (kbd "C-c j") 
		(lambda () (interactive) (find-file "~/org/journal.org")))
(global-set-key (kbd "C-c n") 
		(lambda () (interactive) (find-file "~/org/notes.org")))

(require 'ox-md)


(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq dired-listing-switches "-alh")


;; MAGIT
(use-package magit
  :ensure t
  :bind ("C-c m" . magit-status))





(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-PDF-mode t)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t))

(use-package pdf-tools
  :ensure t
  :config (pdf-tools-install))




(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (agenda   . 5))))


(use-package engine-mode
  :ensure t   ; auto-installs if missing
  :config
  (engine-mode t)
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d"))


;; Celestial mode
(use-package celestial-mode-line
  :ensure t
  :config
  ;; coordinates
  ;; (setq calendar-longitude -76.48)   ; ← change to your longitude
  ;; (setq calendar-latitude  44.2)    ; ← change to your latitude
  ;; (setq calendar-location-name "Kingston")

  (setq calendar-longitude 5.8625); ← change to your longitude
  (setq calendar-latitude  51.8475)    ; ← change to your latitude
  (setq calendar-location-name "Nijmegen")

  ;; (setq celestial-mode-line-phase-representation-alist
  ;;       '((0 . "○") (1 . "☽") (2 . "●") (3 . "☾")))
  ;; (setq celestial-mode-line-sunrise-sunset-alist
  ;;       '((sunrise . "☀↑") (sunset . "☀↓")))

  (if (null global-mode-string)
      (setq global-mode-string '("" celestial-mode-line-string))
    (add-to-list 'global-mode-string 'celestial-mode-line-string t))

  (celestial-mode-line-start-timer))


;; WINNER MODE
(winner-mode 1)



;; KEYBINDINGS
(defun my/open-init ()
  (interactive)
  (find-file "~/.emacs"))

(global-set-key (kbd "C-c i") 'my/open-init)


(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(global-set-key (kbd "C-c k") 'kill-all-buffers)


(defun my/show-file-path ()
  "Show full file path in minibuffer."
  (interactive)
  (let ((path (buffer-file-name)))
    (if path
        (message "%s" path)
      (message "Buffer has no file path"))))



(use-package olivetti
  :ensure t
  :config
  (setq olivetti-body-width 100))


;; Toggle maximize current window

(defvar my/pre-maximize-config nil
  "Saved window configuration before maximizing.")

(defun my/toggle-maximize-window ()
  (interactive)
  (if (one-window-p)
      ;; Restore layout but keep the current buffer
      (when my/pre-maximize-config
        (let ((current-buf (current-buffer)))
          (set-window-configuration my/pre-maximize-config)
          (setq my/pre-maximize-config nil)
          (switch-to-buffer current-buf)))  ;; put new file back ✅
    ;; Save layout and maximize
    (setq my/pre-maximize-config (current-window-configuration))
    (delete-other-windows)))

(global-set-key (kbd "C-x m") 'my/toggle-maximize-window)


(global-set-key (kbd "C-c C-m") 'compose-mail)




(setq ring-bell-function 'ignore)


;; PYRIGHT

(use-package eglot
  :hook (python-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pyright-langserver" "--stdio"))))




(use-package iedit
  :ensure t)


;; EVIL MULTIEDIT
(use-package evil-multiedit
  :ensure t
  :config
  (evil-multiedit-default-keybinds)
  (setq evil-multiedit-follow-matches t))




(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode 1)
  (setf (alist-get 'prettier apheleia-formatters)
        '("/usr/local/bin/prettier"
          "--stdin-filepath" filepath))
  (setf (alist-get 'yaml-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'yaml-ts-mode apheleia-mode-alist) '(prettier)))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (define-key flycheck-mode-map (kbd "C-c !") nil)
  (define-key flycheck-mode-map (kbd "C-c F") flycheck-command-map))

;;DIRED QUICK SORT
(use-package dired-quick-sort
  :ensure t
  :config
  (dired-quick-sort-setup)
  (evil-define-key 'normal dired-mode-map
    (kbd "S") 'hydra-dired-quick-sort/body))



(pixel-scroll-precision-mode 1)
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 5)))


(use-package evil-mc
  :ensure t
  :config
  (global-evil-mc-mode 1))


;; WTTRIN


(use-package wttrin
  :ensure t
  )
(setq wttrin-default-locations '("Nijmegen" "Toronto" "Kitchener"))


(require 'appt)
(appt-activate 1)
(org-agenda-to-appt)
(setq appt-message-warning-time 15)



(defun my/toggle-light-dark ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'ef-autumn)
      (progn
        (disable-theme 'ef-autumn)
        (load-theme 'ef-arbutus t))
    (progn
      (disable-theme 'ef-arbutus)
      (load-theme 'ef-autumn t))))

(global-set-key (kbd "<f5>") 'my/toggle-light-dark)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("05f1ee9db2c66cd715ab6d36ff949386c47dfff91a7df1f203d015b3ea304dbb"
     "851da27a89bcef42d165e29012ef43a0392b78544095aea36e42d4486f6a74fc"
     "8bffaccb8930a5e9e519485c0ed7e13cf4af4c86cda1e62c6d0bc597329776e9"
     "b89b6d95670712b8742f4391416483a29d4315323a218600590160e132c70ec8"
     "e558acb85628028d35a1a4f37af738aa35062f26a6f8bea535048cca1427b4d2"
     "998bc02f2e52205ad06df88a14d53168aef1ec1bbcc6fe2b0cd15fed8e5c8dae"
     "eeaa104f99d641c8be210d3555eba029756d5dc7a2f9a342af526045c3a82c60"
     "f2f42f0b7c53736840fc3ff5751235e3b87cc535b04ddaf3423e2926548bfbb4"
     "5cb84685a211fb46e47ca355dc91e52adf0c185dc0603cfe27c63855f200dd1f"
     "e0fbe5caa6e602975e59cdd381c9773a670a864dd7bb7bf2345414856148098b"
     "4f1641913dd7705f03f5b3271a570d5b4289bdd974665b8919164f2e43799fbd"
     default))
 '(org-agenda-files
   '("/home/avatarjasper/org/todo.org"
     "/home/avatarjasper/org/inbox/ontarioparksbuying.org"
     "/home/avatarjasper/org/thesis/linux_help_commands.org"
     "/home/avatarjasper/org/notes.org"
     "/home/avatarjasper/org/refile.org"))
 '(package-selected-packages
   '(apheleia auctex avy buttercup cape celestial-mode-line comment-tags
	      consult corfu dashboard dired-preview dired-quick-sort
	      ef-themes embark embark-consult evil-collection
	      evil-commentary evil-mc evil-multiedit evil-org
	      evil-surround flycheck iedit keyfreq magit marginalia
	      markdown-mode modus-themes mu4e olivetti orderless
	      org-roam org-super-agenda pdf-tools sqlite3 use-package
	      vertico vim-colors vterm wgrep which-key wttrin yaml
	      yaml-mode zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
