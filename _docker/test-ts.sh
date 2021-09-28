#!/bin/bash

curl -X POST "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=ja" \
     -H "Ocp-Apim-Subscription-Key:${MSATS_KEY}" \
     -H "Ocp-Apim-Subscription-Region:${MSATS_REGION:-japaneast}" \
     -H "Content-Type: application/json" \
     -d "[{'Text':'Hello, what is your name?'}]" | jq .

