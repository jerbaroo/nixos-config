{ codeFontName, flavor }:
{
  home.file.".config/doom/config.el".text = ''
    ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

    ;; Place your private configuration here! Remember, you do not need to run 'doom
    ;; sync' after modifying this file!


    ;; Some functionality uses this to identify you, e.g. GPG configuration, email
    ;; clients, file templates and snippets. It is optional.
    ;; (setq user-full-name "John Doe"
    ;;       user-mail-address "john@doe.com")

    ;; Doom exposes five (optional) variables for controlling fonts in Doom:
    ;;
    ;; - `doom-font' -- the primary font to use
    ;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
    ;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
    ;;   presentations or streaming.
    ;; - `doom-symbol-font' -- for symbols
    ;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
    ;;
    ;; See 'C-h v doom-font' for documentation and more examples of what they
    ;; accept. For example:
    ;;
    ;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
    ;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
    ;;
    ;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
    ;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
    ;; refresh your font settings. If Emacs still can't find your font, it likely
    ;; wasn't installed correctly. Font issues are rarely Doom issues!

    ;; There are two ways to load a theme. Both assume the theme is installed and
    ;; available. You can either set `doom-theme' or manually load a theme with the
    ;; `load-theme' function. This is the default:

    ;; Whenever you reconfigure a package, make sure to wrap your config in an
    ;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
    ;;
    ;;   (after! PACKAGE
    ;;     (setq x y))
    ;;
    ;; The exceptions to this rule:
    ;;
    ;;   - Setting file/directory variables (like `org-directory')
    ;;   - Setting variables which explicitly tell you to set them before their
    ;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
    ;;   - Setting doom variables (which start with 'doom-' or '+').
    ;;
    ;; Here are some additional functions/macros that will help you configure Doom.
    ;;
    ;; - `load!' for loading external *.el files relative to this one
    ;; - `use-package!' for configuring packages
    ;; - `after!' for running code after a package has loaded
    ;; - `add-load-path!' for adding directories to the `load-path', relative to
    ;;   this file. Emacs searches the `load-path' when you load packages with
    ;;   `require' or `use-package'.
    ;; - `map!' for binding new keys
    ;;
    ;; To get information about any of these functions/macros, move the cursor over
    ;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
    ;; This will open documentation for it, including demos of how they are used.
    ;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
    ;; etc).
    ;;
    ;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
    ;; they are implemented.

    (setq display-line-numbers-type t
        doom-font (font-spec :family "${codeFontName}" :size 28)
        doom-theme 'catppuccin
        catppuccin-flavor '${flavor}
        ;; doom-themes-treemacs-theme "doom-colors"
        ;; doom-variable-pitch-font (font-spec :family "${codeFontName}" :size 26)
        ;; lsp-enable-file-watchers nil
        lsp-eldoc-enable-hover nil
        lsp-haskell-server-path "haskell-language-server"
        lsp-lens-enable nil
        org-directory "~/org/"
        org-latex-pdf-process
          '("xelatex -shell-escape -interaction nonstopmode %f"
            "bibtex %b"
            "xelatex -shell-escape -interaction nonstopmode %f")
        user-full-name "jerbaroo"
        user-mail-address "jerbaroo.work@pm.me"
        which-key-idle-delay 0.0
        zoom-size '(0.60 . 0.60)
    )

    (doom/set-frame-opacity 0.8)

    (after! lsp-ui
        (setq
            lsp-ui-doc-delay 0.2
            lsp-ui-doc-enable t
            lsp-ui-doc-show-with-cursor t
            lsp-ui-doc-side 'right
            lsp-ui-doc-position 'top
        )
    )

    (global-display-fill-column-indicator-mode)

    (map!
        "C-h" #'evil-window-left
        "C-j" #'evil-window-down
        "C-k" #'evil-window-up
        "C-l" #'evil-window-right
    )

    (custom-set-faces!
        ;; '(font-lock-comment-face :family "MonaspiceRn Nerd Font")
        '(font-lock-comment-face :family "Cascadia Code" :slant italic)
    )
  '';
}
