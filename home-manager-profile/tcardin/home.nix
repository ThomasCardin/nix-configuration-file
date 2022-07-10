{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tcardin";
  home.homeDirectory = "/home/tcardin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Default packages
  home.packages = with pkgs; [
    kitty alacritty
    git git-crypt
    rustc cargo python38 mockgen pipenv protobuf nodejs go
    neofetch htop gnumake xorg.xhost
    cmake gcc binutils unzip
    openssl gnome.zenity
    obs-studio
    docker docker-compose
    protoc-gen-go
    awscli2 terraform
    polybar flameshot lsof zip tree
    jdk8 maven
    cmatrix asciiquarium
  ];
  
  # Programs
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update-nixos = "sudo nixos-rebuild switch";
      update-home = "home-manager switch";
      cdhome = "cd /home/tcardin";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      theme = "aussiegeek";
    };
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "enhancd";
        file = "init.sh";
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "v2.2.1";
          sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }
    ];
  };

  # Config file home manager
  home.file = {
    # KITTY CONFIG
    ".config/kitty/kitty.conf".text= ''
		font_family 	 Ubuntu
		bold_font 	     auto
		italic_font 	 auto
        bold_italic_font auto
		font_size 12
	
		cursor_text_color #111111
		cursor_beam_thickness 1.5
		cursor_underline_thickness 2.0
		cursor_blink_interval -1

		scrollback_lines 2000
		mouse_hide_wait 3.0
		detect_urls yes
		copy_on_select no

		pointer_shape_when_grabbed arrow
		default_pointer_shape beam
		pointer_shape_when_dragging beam

		enable_audio_bell no

		remember_window_size  no
		initial_window_width  1400
		initial_window_height 1000

		window_border_width 0.5pt
		draw_minimal_borders yes
		window_padding_width 10
		hide_window_decorations yes

    	dim_opacity 0.75

        enabled_layouts tall:bias=50;full_size=1;mirrored=false
	'';
    
    # VIM config file
    ".vimrc".text = ''
        syntax on
    	set tabstop=4 softtabstop=4
        set shiftwidth=4
        set expandtab
        set smartindent

        set exrc
        set guicursor=
        set relativenumber
        set hidden
        set noerrorbells
        set nu
        set nowrap
        set incsearch
        set nohlsearch 
        set termguicolors
        set scrolloff=8
        set signcolumn=yes
        
        " https://github.com/junegunn/vim-plug
        call plug#begin('~/.vim/plugged')

        " FZF
        Plug 'junegunn/fzf.vim'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        
        " Autocomplete
        Plug 'rust-lang/rust.vim'
        let g:rustfmt_autosave = 1

        " THEME
        Plug 'dracula/vim'

        " Disable HJKL and Arrow Keys
        Plug 'wikitopian/hardmode'
        call plug#end()
        
        set background=dark        
        colorscheme dracula
        
        # Work around using a vim background 
        set t_ut=

        " hjkl also off
        " autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
        noremap <Up> <Nop>
        noremap <Down> <Nop>
        noremap <Left> <Nop>
        noremap <Right> <Nop>

    '';

    # ALACRITTY CONFIG
    ".config/alacritty/alacritty.yml".text = ''
        env:
            TERM: xterm-256color
        # Window configuration
        window:
            dimensions:
                columns: 160
                lines: 50
            padding:
                x: 10
                y: 10

            title: Alacritty
            dynamic_title: true
            class:
                instance: Alacritty
                general: Alacritty

        scrolling:
            history: 10000

        background_opacity: 0.95

        # Font configuration
        font:
            normal:
                family: monospace
                style: Regular
            bold:
                family: monospace
                style: Bold
            italic:
                family: monospace
                style: Italic
            bold_italic:
                family: monospace
                style: Bold Italic
            size: 12.0
            offset:
                x: 0
                y: 0
            glyph_offset:
                x: 0
                y: 0

        draw_bold_text_with_bright_colors: true

        # Colors (Night Owl)
        colors:
            # Default colors
            primary:
                background: '#011627'
                foreground: '#d6deeb'

            cursor:
                text: '#011627'
                cursor: '#d6deeb'

            selection:
                background: '#1b90dd'

            # Normal colors
            normal:
                black:   '#011627'
                red:     '#ef5350'
                green:   '#22da6e'
                yellow:  '#c5e478'
                blue:    '#82aaff'
                magenta: '#c792ea'
                cyan:    '#21c7a8'
                white:   '#ffffff'

             # Bright colors
            bright:
                black:   '#575656'
                red:     '#ef5350'
                green:   '#22da6e'
                yellow:  '#ffeb95'
                blue:    '#82aaff'
                magenta: '#c792ea'
                cyan:    '#7fdbca'
                white:   '#ffffff'
    '';
  };
}



