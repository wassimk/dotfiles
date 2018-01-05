if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# Hit Enter to repeat last command
Pry::Commands.command (/^$/), 'repeat last command' do
  _pry_.run_command Pry.history.to_a.last
end

if defined?(PryRails::RAILS_PROMPT)
  Pry.config.prompt = PryRails::RAILS_PROMPT
end

def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

def me(place)
  case place
  when :fabricut
    User.find_by(email: 'wassim.metallaoui@fabricut.com')
  when :shipzen
    User.find_by(email: 'wassim@shipzen.com')
  else
    User.find_by(email: 'wassim@metallaoui.com')
  end
end

