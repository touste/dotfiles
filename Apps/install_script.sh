# Apps dir
echo "Making Apps dir"
mkdir -p $HOME/Apps

# Prezto
echo "Installing Prezto for zsh"
# z jump
git clone https://github.com/agkozak/zsh-z.git $HOME/.zprezto-contrib/zsh-z

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Remove zpreztorc as it will be added later on
rm $HOME/.zprezto/runcoms/zpreztorc

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done


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

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
LINE="alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"
FILE=$HOME/.zshrc
grep -xqF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

git clone --bare https://github.com/touste/dotfiles $HOME/.dotfiles

dotfiles checkout || echo -e 'Deal with conflicting files, then run (possibly with -f flag if you are OK with overwriting)\ndotfiles checkout'

dotfiles config --local status.showUntrackedFiles no




# Tips
echo "Don't forget to change your default shell: chsh -s $(which zsh)"

