# Apps dir
echo "Making Apps dir"
mkdir -p $HOME/Apps

# Prezto
echo "Installing Prezto for zsh"
# z jump
git clone https://github.com/agkozak/zsh-z.git $HOME/.zprezto-contrib/zsh-z

zsh -i -c 'git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"'

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

chsh -s $(which zsh)


# Get micro
echo "Installing micro editor"
cd .local/bin
curl https://getmic.ro | bash
cd $HOME

# Add .local/bin to path
echo "Adding .local/bin to path"
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
  echo ".local/bin already in path"
else
  echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.zshrc
fi

# Configure dotfile repo (https://www.atlassian.com/git/tutorials/dotfiles)
echo "Importing dotfiles..."

alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc

git clone --bare <git-repo-url> $HOME/.cfg

mkdir -p .config/config-backup && \
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config/config-backup/{}

dotfiles checkout

dotfiles config --local status.showUntrackedFiles no

