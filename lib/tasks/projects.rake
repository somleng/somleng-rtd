namespace :projects do
  desc "Fetches project usage info"
  task :fetch => :environment do
    Project.fetch!
  end

  def prompt_for_input(prompt, options = {})
    placeholder = options[:placeholder] || DEFAULT_PLACEHOLDER if options[:placeholder] != false
    prompt_text = prompt
    prompt_text += " (Default: #{placeholder})" if placeholder
    prompt_text += ": "
    puts(prompt_text)
    response = STDIN.gets.chomp
    response = placeholder if placeholder && response.empty?
    if options[:attribute] && options[:model]
      options[:model].public_send("#{options[:attribute]}=", response)
      if !options[:model].valid?
        errors = options[:model].errors[options[:attribute]]
        if errors.any?
          puts(errors.to_sentence)
          response = prompt_for_input(prompt, options)
        end
      end
    end
    response
  end

  desc "Creates a new project"
  task :create => :environment do
    Signal.trap('INT') do
      exit 130
    end

    DEFAULT_PLACEHOLDER = "CHANGE_ME"

    project = Project.new(
      :phone_calls_count => 0,
      :sms_count => 0,
      :amount_saved => 0,
    )

    prompt_for_input(
      "Project Name",
      :placeholder => false,
      :attribute => :name,
      :model => project
    )

    prompt_for_input(
      "Project Description",
      :placeholder => false,
      :attribute => :description,
      :model => project
    )

    prompt_for_input(
      "Project Homepage",
      :placeholder => false,
      :attribute => :homepage,
      :model => project
    )

    prompt_for_input(
      "Twilreapi Hostname",
      :placeholder => false,
      :attribute => :twilreapi_host,
      :model => project
    )

    prompt_for_input(
      "Twilreapi Account Sid",
      :placeholder => false,
      :attribute => :twilreapi_account_sid,
      :model => project
    )

    prompt_for_input(
      "Twilreapi Auth Token",
      :placeholder => false,
      :attribute => :twilreapi_auth_token,
      :model => project
    )

    project_country_code = prompt_for_input(
      "Project Country Code",
      :placeholder => "KH"
    )

    puts("Fetching Twilio Price for #{project_country_code}...")

    TwilioPrice.fetch_new!(project_country_code)
    project.twilio_price = TwilioPrice.find_by_country_code(project_country_code)

    if project.valid?
      project.save!
      puts "New Project Created: #{project.inspect}"
    else
      puts(project.errors.full_messages.to_sentence)
    end
  end
end
