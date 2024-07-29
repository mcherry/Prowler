#!/bin/bash
#/ Prowler 
#/ Usage: prowler.sh [-hukaedpl]
#/
#/ Send prowl notifications from the shell using cURL.
#/
#/ OPTIONS:
#/   -h               | --help                Show this message.
#/   -u <API_URL>     | --url <API_URL>       The URL for the API endpoint. If no URL is
#/                                            specified the default public API endpoint
#/                                            is used.
#/   -k <API_KEY>     | --key <API_KEY>       Specify the API key. This script will look
#/                                            for the presence of ~/.prowl_api_key and if
#/                                            not found will require the API key to be
#/                                            specified with this argument. If this is a
#/                                            file the contents will be used as the API
#/                                            key, otherwise this value will be used as 
#/                                            a API key.
#/   -a [application] | --app [application]   The name of the application sending the
#/                                            notification. If not specified the script
#/                                            name will be used.
#/   -e [event]       | --event [event]       The event that occurred for this notification.
#/                                            If no event is specified the string
#/                                            "Notification" will be used.
#/   -d <description> | --desc <description>  A description of the notification.
#/   -p [priority]    | --priority [priority] An integer value ranging [-2, 2] representing:
#/                                              -2 Very Low
#/                                              -1 Moderate
#/                                               0 Normal
#/                                               1 High
#/                                               2 Emergency
#/   -l [link]        | --link [link]         A URL to be attached to the notification.
#/

CURL_CMD=`command -v curl`
GREP_CMD=`command -v grep`
TR_CMD=`command -v tr`
SED_CMD=`command -v sed`
CAT_CMD=`command -v cat`

function show_help() { $GREP_CMD '^#/' < "$0" | cut -c4-; }
function echo_error() { echo "ERROR: $1"; exit 1; }

if [ ! $CURL_CMD ]; then echo_error "curl command not found"; fi
if [ ! $GREP_CMD ]; then echo_error "grep not found"; fi
if [ ! $TR_CMD ]; then echo_error "tr not found"; fi
if [ ! $SED_CMD ]; then echo_error "sed not found"; fi
if [ ! $CAT_CMD ]; then echo_error "cat not found"; fi

API_URL="https://api.prowlapp.com/publicapi/add"
API_FILE="~/.prowl_api_key"
if [ -f $API_FILE ]; then API_KEY=`$CAT_CMD $API_FILE`; fi

NOTE_APP="prowler.sh"
NOTE_EVENT="Notification"
NOTE_PRIORITY="0"
NOTE_URL=""

# process command line arguments
ARGUMENTS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help ;;
        -u|--url)
            API_URL="$2"
            shift && shift
            ;;
        -k|--key)
            if [ -f "$2" ]; then
                API_KEY=`$CAT_CMD "$2"`
            else
                API_KEY="$2"
            fi
            shift && shift
            ;;
        -a|--app)
            NOTE_APP="$2"
            shift && shift
            ;;
        -e|--event)
            NOTE_EVENT="$2"
            shift && shift
            ;;
        -d|--desc)
            NOTE_DESC="$2"
            shift && shift
            ;;
        -p|--priority)
            NOTE_PRIORITY="$2"
            shift && shift
            ;;
        -l|--link)
            NOTE_URL="$2"
            shift && shift
            ;;
        -*|--*)
            show_help && exit ;;
        *)
            ARGUMENTS+=("$1")
            shift
            ;;
    esac
done
set -- "${ARGUMENTS[@]}"

if [ ! $API_URL ]; then show_help && echo_error "API URL not found."; fi
if [ ! $NOTE_DESC ]; then show_help && echo_error "Description is a required argument."; fi

OUTPUT=`$CURL_CMD -s -d "apikey=$API_KEY&application=$NOTE_APP&event=$NOTE_EVENT&description=$NOTE_DESC&priority=$NOTE_PRIORITY&url=$NOTE_URL" -X POST "$API_URL"`
SUCCESS=`echo "$OUTPUT"|$GREP_CMD -i success`
if [ ! "$SUCCESS" ]; then 
    ERROR=`echo "$OUTPUT"|$TR_CMD -d '\n'|$SED_CMD -e 's/<[^>]*>//g'`
    echo_error "$ERROR"
else
    echo "Success"
fi
