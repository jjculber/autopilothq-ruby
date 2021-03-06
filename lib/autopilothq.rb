require 'rest_client'
require 'json'

class Autopilothq

  def self.api_key=(key)
    @@api_key = key
  end

  def self.update_contact(email, custom_attrs)
    if @@api_key.present?
      attributes = {
        "contact" => {
          "Email" => email,
          "custom" => {}
        }
      }
      custom_attrs.each_pair{ |key, (type,value)|
        next if value.nil?
        if type == "date"
          value = value.to_i * 1000
        end
        attributes['contact']['custom'][get_key_name(key, type)] = value
      }

      response = RestClient.post 'https://api2.autopilothq.com/v1/contact', attributes.to_json, headers
    end

    return true
  rescue RestClient::RequestFailed => e
    return false
  end
    
  def self.headers
    return {
      :autopilotapikey => @@api_key,
    }
  end

  def self.get_key_name(name, type)
    return "#{type}--#{name.gsub(/\s+/, "--")}"
  end
end
