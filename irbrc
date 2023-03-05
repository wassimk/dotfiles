#
# .irbrc - interactive ruby shell configuration
#

class Prompt
  class << self
    def app_name
      Rails.application.railtie_name.chomp("_application").sub!("_", "-")
    end

    def formatted_env
      env = { "development" => "dev", "staging" => "stag", "production" => "prod" }.fetch(
        Rails.env,
        Rails.env,
      )

      if Rails.env.production? || Rails.env.staging?
        "\u001b[1;31;49m#{env}\u001b[0m" # bold red
      elsif Rails.env.development?
        "\u001b[0;32;49m#{env}\u001b[0m" # green
      else
        env
      end
    end
  end
end

prompt =
  if defined?(Rails)
    name = :RAILS_PROMPT

    IRB.conf[:PROMPT][name] = {
      PROMPT_I: "#{Prompt.app_name}:#{Prompt.formatted_env}> ",
      RETURN: "=> %s\n",
    }

    name
  else
    :DEFAULT
  end

IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:PROMPT_MODE] = prompt

#
# Useful debugging methods
# 

class Class
  public :include

  def class_methods
    (methods - Class.instance_methods - Object.methods).sort
  end

  def defined_methods
    methods = {}

    methods[:instance] = new.local_methods
    methods[:class] = class_methods

    methods
  end
end

class Object
  def defined_methods
    (methods - Object.instance_methods).sort
  end
end
