# Minimal Home Manager Fish Configuration
# Run with: nix run github:nix-community/home-manager -- switch --flake github:yourusername/nixos-config#mikolajbien
# Or locally: nix run .#homeConfigurations.mikolajbien.activationPackage

{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting

      if status is-interactive
          # Commands to run in interactive sessions can go here
      end

      if type -q ssh-agent
          if test -z "$(pgrep ssh-agent)"
              eval (ssh-agent -c)
              set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
              set -Ux SSH_AGENT_PID $SSH_AGENT_PID
              set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
          end
      end

      # bun
      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH
    '';

    shellAbbrs = {
      lg = "lazygit";
      rr = "rm -r";
      rf = "rm -rf";
      l = "ls -lh";
      nrd = "nr dev";
    };

    functions = {
      fish_prompt = ''
        set -l last_status $status

        set -l normal (set_color normal)
        set -l usercolor (set_color $fish_color_user)

        set -l delim " > "
        # If we don't have unicode use a simpler delimiter
        string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL; or set delim " > "

        fish_is_root_user; and set delim "#"

        set -l cwd (set_color green)

        # Prompt status only if it's not 0
        set -l prompt_status
        test $last_status -ne 0; and set prompt_status (set_color $fish_color_status)"[$last_status]$normal"

        # Only show host if in SSH or container
        # Store this in a global variable because it's slow and unchanging
        if not set -q prompt_host
            set -g prompt_host ""
            if set -q SSH_TTY
                or begin
                    command -sq systemd-detect-virt
                    and systemd-detect-virt -q
                end
                set prompt_host $usercolor$USER$normal@(set_color $fish_color_host)$hostname$normal":"
            end
        end

        # Shorten pwd if prompt is too long
        set -l pwd (prompt_pwd)

        echo -n -s " " $prompt_host $cwd $pwd $normal $prompt_status $delim
      '';

      fish_right_prompt = ''
        set -g __fish_git_prompt_showdirtystate 1
        set -g __fish_git_prompt_showuntrackedfiles 1
        set -g __fish_git_prompt_showupstream informative
        set -g __fish_git_prompt_showcolorhints 1
        set -g __fish_git_prompt_use_informative_chars 1
        # Unfortunately this only works if we have a sensible locale
        string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL
        and set -g __fish_git_prompt_char_dirtystate \U1F4a9
        set -g __fish_git_prompt_char_untrackedfiles "?"

        # The git prompt's default format is ' (%s)'.
        # We don't want the leading space.
        set -l vcs (fish_vcs_prompt '(%s)' 2>/dev/null)

        # set -l d (set_color brgrey)(date "+%R")(set_color normal)

        set -l duration "$cmd_duration$CMD_DURATION"
        if test $duration -gt 100
            set duration (math $duration / 1000)s
        else
            set duration
        end

        set -q VIRTUAL_ENV_DISABLE_PROMPT
        or set -g VIRTUAL_ENV_DISABLE_PROMPT true
        set -q VIRTUAL_ENV
        and set -l venv (string replace -r '.*/' "" -- "$VIRTUAL_ENV")

        set_color normal
        string join " " -- $venv $duration $vcs
      '';
    };

    interactiveShellInit = ''
      # Platform-specific aliases
      switch (uname -s)
          case Darwin
              alias studio="open -a $HOME/Applications/Android\ Studio.app"
          case Linux
          case '*'
      end

      # Tool initializations
      if type -q fnm
          fnm env | source
      end

      if type -q zoxide
          zoxide init fish | source
      end

      if test -f "$HOME/.cargo/env.fish"
          source "$HOME/.cargo/env.fish"
      end
    '';
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.bun/bin"
    "$HOME/.turso"
    "$HOME/.cargo/env"
    "$HOME/.cargo/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.local/share/bob/nvim-bin"
    "/nix/var/nix/profiles/default/bin"
    "/opt/local/bin"
  ];

  # Force overwrite existing files
  xdg.configFile."fish/config.fish".force = true;
  xdg.configFile."fish/functions/fish_prompt.fish".force = true;
  xdg.configFile."fish/functions/fish_right_prompt.fish".force = true;

  # Custom fish functions
  xdg.configFile."fish/functions/fish_prompt.fish".text = ''
    function fish_prompt
        set -l last_status $status

        set -l normal (set_color normal)
        set -l usercolor (set_color $fish_color_user)

        set -l delim " > "
        # If we don't have unicode use a simpler delimiter
        string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL; or set delim " > "

        fish_is_root_user; and set delim "#"

        set -l cwd (set_color green)

        # Prompt status only if it's not 0
        set -l prompt_status
        test $last_status -ne 0; and set prompt_status (set_color $fish_color_status)"[$last_status]$normal"

        # Only show host if in SSH or container
        # Store this in a global variable because it's slow and unchanging
        if not set -q prompt_host
            set -g prompt_host ""
            if set -q SSH_TTY
                or begin
                    command -sq systemd-detect-virt
                    and systemd-detect-virt -q
                end
                set prompt_host $usercolor$USER$normal@(set_color $fish_color_host)$hostname$normal":"
            end
        end

        # Shorten pwd if prompt is too long
        set -l pwd (prompt_pwd)

        echo -n -s " " $prompt_host $cwd $pwd $normal $prompt_status $delim
    end
  '';

  xdg.configFile."fish/functions/fish_right_prompt.fish".text = ''
    function fish_right_prompt
        set -g __fish_git_prompt_showdirtystate 1
        set -g __fish_git_prompt_showuntrackedfiles 1
        set -g __fish_git_prompt_showupstream informative
        set -g __fish_git_prompt_showcolorhints 1
        set -g __fish_git_prompt_use_informative_chars 1
        # Unfortunately this only works if we have a sensible locale
        string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL
        and set -g __fish_git_prompt_char_dirtystate \U1F4a9
        set -g __fish_git_prompt_char_untrackedfiles "?"

        # The git prompt's default format is ' (%s)'.
        # We don't want the leading space.
        set -l vcs (fish_vcs_prompt '(%s)' 2>/dev/null)

        # set -l d (set_color brgrey)(date "+%R")(set_color normal)

        set -l duration "$cmd_duration$CMD_DURATION"
        if test $duration -gt 100
            set duration (math $duration / 1000)s
        else
            set duration
        end

        set -q VIRTUAL_ENV_DISABLE_PROMPT
        or set -g VIRTUAL_ENV_DISABLE_PROMPT true
        set -q VIRTUAL_ENV
        and set -l venv (string replace -r '.*/' "" -- "$VIRTUAL_ENV")

        set_color normal
        string join " " -- $venv $duration $vcs
    end
  '';
}
