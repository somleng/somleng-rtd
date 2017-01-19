# Getting Started

## Projects

The projects API endpoint returns a list of Projects which are currently using Somleng. See the example response for more information.

### List All Projects

#### API Endpoint

```
http://rtd.somleng.org/api/projects.json
```

#### Example Request

```
curl http://rtd.somleng.org/api/projects.json
```

#### Example Response

```json
[
  {
    "id": "6bb193d9-876e-4846-a42f-8a35db66b477",
    "phone_calls_count": 6026,
    "sms_count": 0,
    "name": "Disaster Risk Reduction and Preparedness in Cambodia",
    "description": "Cambodia's geographical location, available resources, and frequency as well magnitude of disasters makes its population very vulnerable to impacts of disasters such as floods, droughts, tropical storms and hurricanes. While emergency aid is the cornerstone of People in Need's work worldwide, the organization believes that the most work that is required is building the institutional capacity of local authorities responsible for disaster management and strengthening the resilience of at-risk communities to help them to be better prepared for disasters.",
    "homepage": "https://www.clovekvtisni.cz/en/humanitary-aid/country/cambodia/programs#disaster-risk-reduction-and-preparedness-in-cambodia",
    "date_updated": "Thu, 19 Jan 2017 08:36:08 +0000",
    "date_created": "Thu, 08 Dec 2016 06:07:04 +0000",
    "twilio_price": {
      "country_code": "KH",
      "date_updated": "Thu, 08 Dec 2016 03:04:57 +0000",
      "date_created": "Thu, 08 Dec 2016 03:04:57 +0000",
      "outbound_voice_price": "$0.100000",
      "outbound_sms_price": "$0.044000",
      "voice_url": "https://www.twilio.com/voice/pricing/kh",
      "sms_url": "https://www.twilio.com/sms/pricing/kh"
    },
    "amount_saved": "$598.99"
  },
  {
    "id": "822cca23-aa9a-4a18-9a6b-8460a2bd7f2c",
    "phone_calls_count": 1963,
    "sms_count": 0,
    "name": "Healthy Family Community (mHealth)",
    "description": "Beginning in Kampong Chhnang Province in 2013, the Healthy Family Community project uses mobile phone technology to deliver health messages regarding maternal and child health. Mothers and pregnant women who have registered receive automatic prerecorded voice messages to their phone which are designed to improve health behaviours and increase health service demand. These messages provide information and advice on a range of topics, such as avoiding harmful traditional health practices, and improving nutrition of the mother and baby.",
    "homepage": "https://www.clovekvtisni.cz/en/humanitary-aid/country/cambodia/programs#healthy-family-community-mhealth",
    "date_updated": "Thu, 19 Jan 2017 08:36:09 +0000",
    "date_created": "Wed, 16 Nov 2016 09:46:31 +0000",
    "twilio_price": {
      "country_code": "KH",
      "date_updated": "Thu, 08 Dec 2016 03:04:57 +0000",
      "date_created": "Thu, 08 Dec 2016 03:04:57 +0000",
      "outbound_voice_price": "$0.100000",
      "outbound_sms_price": "$0.044000",
      "voice_url": "https://www.twilio.com/voice/pricing/kh",
      "sms_url": "https://www.twilio.com/sms/pricing/kh"
    },
    "amount_saved": "$34.09"
  }
]
```

### Retrieve a Project

#### API Endpoint

```
http://rtd.somleng.org/api/projects/:project_id.json
```

#### Example Request

```
curl http://rtd.somleng.org/api/projects/6bb193d9-876e-4846-a42f-8a35db66b477.json
```

#### Example Response

```json
{
  "id": "6bb193d9-876e-4846-a42f-8a35db66b477",
  "phone_calls_count": 6026,
  "sms_count": 0,
  "name": "Disaster Risk Reduction and Preparedness in Cambodia",
  "description": "Cambodia's geographical location, available resources, and frequency as well magnitude of disasters makes its population very vulnerable to impacts of disasters such as floods, droughts, tropical storms and hurricanes. While emergency aid is the cornerstone of People in Need's work worldwide, the organization believes that the most work that is required is building the institutional capacity of local authorities responsible for disaster management and strengthening the resilience of at-risk communities to help them to be better prepared for disasters.",
  "homepage": "https://www.clovekvtisni.cz/en/humanitary-aid/country/cambodia/programs#disaster-risk-reduction-and-preparedness-in-cambodia",
  "date_updated": "Thu, 19 Jan 2017 08:36:08 +0000",
  "date_created": "Thu, 08 Dec 2016 06:07:04 +0000",
  "twilio_price": {
    "country_code": "KH",
    "date_updated": "Thu, 08 Dec 2016 03:04:57 +0000",
    "date_created": "Thu, 08 Dec 2016 03:04:57 +0000",
    "outbound_voice_price": "$0.100000",
    "outbound_sms_price": "$0.044000",
    "voice_url": "https://www.twilio.com/voice/pricing/kh",
    "sms_url": "https://www.twilio.com/sms/pricing/kh"
  },
  "amount_saved": "$598.99"
}
```

## Real Time Data

The Real Time Data API endpoint retuns aggregate data about all the projects that are using Somleng. See the example response for more information.

### Retrieve Real Time Data

#### API Endpoint

```
http://rtd.somleng.org/api/real_time_data.json
```

#### Example Request

```
curl http://rtd.somleng.org/api/real_time_data.json
```

#### Example Response

```json
{
  "date_updated": "Thu, 19 Jan 2017 08:36:09 +0000",
  "phone_calls_count": 7989,
  "sms_count": 0,
  "projects_count": 2,
  "amount_saved": "$633.08"
}
```
