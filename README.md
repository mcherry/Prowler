# Prowler
Send [prowl](https://www.prowlapp.com/) notifications from the shell using cURL. 

# Usage
prowler.sh [-hukaedpl]

OPTIONS:
  -h               | --help                Show this message.
  -u <API_URL>     | --url <API_URL>       The URL for the API endpoint. If no URL is
                                           specified the default public API endpoint
                                           is used.
  -k <API_KEY>     | --key <API_KEY>       Specify the API key. This script will look
                                           for the presence of ~/.prowl_api_key and if
                                           not found will require the API key to be
                                           specified with this argument. If this is a
                                           file the contents will be used as the API
                                           key, otherwise this value will be used as 
                                           a API key.
  -a [application] | --app [application]   The name of the application sending the
                                           notification. If not specified the script
                                           name will be used.
  -e [event]       | --event [event]       The event that occurred for this notification.
                                           If no event is specified the string
                                           "Notification" will be used.
  -d <description> | --desc <description>  A description of the notification.
  -p [priority]    | --priority [priority] An integer value ranging [-2, 2] representing
                                             -2 Very Low
                                             -1 Moderate
                                              0 Normal
                                              1 High
                                              2 Emergency
  -l [link]        | --link [link]         A URL to be attached to the notification.

# API Key
An API key is required to use this script. You can get one by logging into your account [here](https://www.prowlapp.com/).
