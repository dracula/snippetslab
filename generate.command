#! /bin/zsh --no-rcs --pipe-fail --aliases
source /etc/profile
if ((!$+commands[npm])) exit 1

alias read="read -d ''"
alias  npx="npx --yes --cache $TMPDIR --quiet"

if builtin read -t
then read
else read < ${1:-dracula.styl}
  brew tap dracula/install --quiet
  $0:r.rb
  output=Dracula.css
fi

echo '/* Dracula theme */\n' >> ${output:=/dev/stdout}
npx stylus --include-css --print <<< $REPLY | grep --invert-match rgb |
npx clean-css-cli -O2 mergeSemantically:on --format beautify |
sed 's/}/&\n/' >> $output
