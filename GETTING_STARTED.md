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
    "id": "822cca23-aa9a-4a18-9a6b-8460a2bd7f2c",
    "phone_calls_count": 0,
    "sms_count": 0,
    "amount_saved": 0,
    "name": "Healthy Family Community (mHealth)",
    "description": "Beginning in Kampong Chhnang Province in 2013, the Healthy Family Community project uses mobile phone technology to deliver health messages regarding maternal and child health. Mothers and pregnant women who have registered receive automatic prerecorded voice messages to their phone which are designed to improve health behaviours and increase health service demand. These messages provide information and advice on a range of topics, such as avoiding harmful traditional health practices, and improving nutrition of the mother and baby.",
    "homepage": "https://www.clovekvtisni.cz/en/humanitary-aid/country/cambodia/programs#healthy-family-community-mhealth",
    "country_code": "KH",
    "phone_call_average_cost_per_minute": "0.05",
    "sms_average_cost_per_message": "0.02",
    "date_updated": "Wed, 16 Nov 2016 09:46:31 +0000",
    "date_created": "Wed, 16 Nov 2016 09:46:31 +0000",
    "twilio_phone_call_cost_per_minute": 0.1,
    "twilio_sms_cost_per_message": 0.044,
    "twilio_phone_call_pricing_url": "https://www.twilio.com/voice/pricing/kh",
    "twilio_sms_pricing_url": "https://www.twilio.com/sms/pricing/kh",
    "currency": "USD"
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
curl http://rtd.somleng.org/api/projects/822cca23-aa9a-4a18-9a6b-8460a2bd7f2c.json
```

#### Example Response

```json
{
  "id": "822cca23-aa9a-4a18-9a6b-8460a2bd7f2c",
  "phone_calls_count": 0,
  "sms_count": 0,
  "amount_saved": 0,
  "name": "Healthy Family Community (mHealth)",
  "description": "Beginning in Kampong Chhnang Province in 2013, the Healthy Family Community project uses mobile phone technology to deliver health messages regarding maternal and child health. Mothers and pregnant women who have registered receive automatic prerecorded voice messages to their phone which are designed to improve health behaviours and increase health service demand. These messages provide information and advice on a range of topics, such as avoiding harmful traditional health practices, and improving nutrition of the mother and baby.",
  "homepage": "https://www.clovekvtisni.cz/en/humanitary-aid/country/cambodia/programs#healthy-family-community-mhealth",
  "country_code": "KH",
  "phone_call_average_cost_per_minute": "0.05",
  "sms_average_cost_per_message": "0.02",
  "date_updated": "Wed, 16 Nov 2016 09:46:31 +0000",
  "date_created": "Wed, 16 Nov 2016 09:46:31 +0000",
  "twilio_phone_call_cost_per_minute": 0.1,
  "twilio_sms_cost_per_message": 0.044,
  "twilio_phone_call_pricing_url": "https://www.twilio.com/voice/pricing/kh",
  "twilio_sms_pricing_url": "https://www.twilio.com/sms/pricing/kh",
  "currency": "USD"
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
  "date_updated": "Wed, 16 Nov 2016 09:46:31 +0000",
  "phone_calls_count": 0,
  "sms_count": 0,
  "projects_count": 1,
  "amount_saved": 0,
  "currency": "USD"
}
```
