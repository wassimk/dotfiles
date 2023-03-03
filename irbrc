class Prompt
  class << self
    def app_name
      Rails.application.railtie_name.chomp('_application')
    end

    def formatted_env
      env = { "development" => "dev", "staging" => "stag", "production" => "prod" }.fetch(
        Rails.env,
        Rails.env,
      )

      if Rails.env.production? || Rails.env.staging?
        "\u001b[1;31;49m#{env}\u001b[0m" # bold red
      elsif Rails.env.development?
        env.green
        "\u001b[0;32;49m#{env}\u001b[0m" # green
      else
        env
      end
    end
  end
end

IRB.conf[:USE_AUTOCOMPLETE] = false

IRB.conf[:PROMPT][:RAILS_PROMPT] = {
  PROMPT_I: "#{Prompt.app_name}:#{Prompt.formatted_env}> ",
  RETURN: "=> %s\n"

}

IRB.conf[:PROMPT_MODE] = :RAILS_PROMPT if defined?(Rails)

