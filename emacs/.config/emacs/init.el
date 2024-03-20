
;; Custom variables
(setq sync-folder "~/Sync/")

;; Custom functions
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun my-kill-ediff-buffers ()
  (interactive)
  (kill-buffer ediff-buffer-A)
  (kill-buffer ediff-buffer-B)
  (kill-buffer ediff-buffer-C))

(defun cb/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(defun affe-orderless-regexp-compiler (input _type _ignorecase)
  (setq input (orderless-pattern-compiler input))
  (cons input (lambda (str) (orderless--highlight input str))))


;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))


;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/") 
                         ("elpa" . "https://elpa.gnu.org/packages/"))
      package-archives-priorities '(("melpa-stable" . 10)
                                    ("elpa" . 5)
                                    ("melpa" . 0)))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(require 'use-package)


(use-package emacs
  :config
  ;; ESC cancel
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ;; Virtual line mode
  (global-visual-line-mode 1)

  ;; Remove default GUI
  (tool-bar-mode -1)
  (toggle-scroll-bar -1)
  (menu-bar-mode -1)

  ;; enable y/n answers
  (fset 'yes-or-no-p 'y-or-n-p)

  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab)

  ;; Remove default startup screen
  (setq inhibit-startup-screen t)
  (setq inhibit-splash-screen t)
  ;; set default height / width
  (add-to-list 'default-frame-alist '(height . 50))
  (add-to-list 'default-frame-alist '(width . 150))

  ;; stop back up and autosave files
  (setq make-backup-files nil)
  (setq auto-save-default nil)

  ;; enable vim relative numbering
  (setq-default display-line-numbers-type 'relative
                display-line-numbers-current-absolute t)

  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)

  ;; enable system clipboard support
  (setq x-select-enable-clipboard t)

  ;; The default is 800 kilobytes.  Measured in bytes.
  (setq gc-cons-threshold (* 50 1000 1000))

  ;; remove emacs own list-buffer key
  (global-set-key (kbd "C-x C-b") nil)

  ;; remove emacs own list-buffer key
  (global-set-key (kbd "C-M-\\") nil)

  ;; Silence compiler warnings as they can be pretty disruptive
  (setq comp-async-report-warnings-errors nil)
  ;; Set fonts
  (add-to-list 'default-frame-alist
               '(font . "FantasqueSansMono Nerd Font Mono-14"))

  ;; undo tree folder
  (setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo")))

  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq visible-bell t)


  :bind(("M-\\" . indent-region-function)));

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))

(use-package ssh-agency
  :ensure t )

;; change theme
(use-package dracula-theme
  :init (load-theme 'dracula t)
  :defer t
  :ensure t)

(use-package autorevert
  :diminish auto-revert-mode
  :config
  (setq auto-revert-check-vc-info t)
  (global-auto-revert-mode t))

(use-package paren
  :config
  (setq show-paren-style 'parenthesis)
  (show-paren-mode 1))

(use-package smartparens
  :ensure t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-fu)
  :config
  (add-hook 'evil-mode-hook 'cb/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package keychain-environment
  :ensure t
  :config
  (keychain-refresh-environment))

(use-package magit
  :ensure t
  :init
  (setq magit-repository-directories
        '(("~/workspace/projects/" . 3)))
  :bind (("C-x g" . magit-status))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless)))

(use-package embark
  :ensure t
  :bind
  (("M-RET" . embark-act)       ;; pick some comfortable binding
   ("M-'" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :ensure t
  :pin melpa-stable
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x C-b" . consult-buffer)              ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("C-s" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key "M-.")

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the mini buffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (project-roots)
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-root-function #'vc-root-dir)
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-root-function (lambda () (locate-dominating-file "." ".git")))
  )

(use-package affe
  :config
  ;; Manual preview key for `affe-grep'
  (consult-customize affe-grep :preview-key (kbd "M-."))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler))


(use-package corfu
  :ensure t
  :bind (:map corfu-map
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous)
              ("C-f" . corfu-insert))
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package lsp-mode
  :ensure t
  :commands(lsp lsp-deferred)
  :init(setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;; Programming modes

(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-mode . lsp-deferred))

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))


(use-package flyspell
  :custom
  (ispell-program-name "aspell")
  ;; Default dictionary. To change do M-x ispell-change-dictionary RET.
  (aspell-dictionary "en_GB-ise-wo_accents")
  (aspell-program-name "/usr/bin/aspell")
  (ispell-dictionary "en_GB-ise-wo_accents")
  (ispell-program-name "/usr/bin/aspell")
  :config
  (define-key flyspell-mode-map [down-mouse-3] 'flyspell-correct-word)
  (add-hook 'org-mode-hook 'flyspell-mode)
  ;; Enable Flyspell program mode for emacs lisp mode, which highlights all misspelled words in comments and strings.
  (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode))


(use-package flyspell-correct
  :bind ("C-," . flyspell-correct-wrapper)) 


(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package projectile
  :ensure t
  :pin melpa-stable
  :init
  (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/workspace/projects/" ))
  (setq projectile-switch-project-action #'projectile-dired)
  :bind (:map projectile-mode-map
              ("M-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


(use-package undo-fu
  :ensure t) 

(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package tree-sitter-langs
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult-lsp affe tree-sitter-langs tree-sitter undo-fu emacs-undo-fu minimap rainbow-delimiters company-tabnine ample-theme org-roam flycheck company-box company lsp-ui lsp-mode corfu gruvbox-theme embark-consult embark orderless marginalia vertico which-key use-package magit evil-collection)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
