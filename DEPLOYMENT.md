# Deployment

## Heroku

### Setup ENV vars

`TWILIO_ACCOUNT_SID` and `TWILIO_AUTH_TOKEN` are needed to update the Twilio prices only.

```
$ heroku config:set TWILIO_ACCOUNT_SID=your_twilio_account_sid TWILIO_AUTH_TOKEN=your_twilio_auth_token
```

### Configuring Heroku Scheduler

1. Provision the Heroku Scheduler add-on
2. Add a job for updating Twilio prices: `rake twilio_price:fetch`
3. Add a job for updating project data: `rake projects:fetch`

### Creating a new Project

```
$ heroku run rails projects:create
```

### Adding a new Twilio Price

```
$ heroku config:set TWILIO_PRICE_COUNTRIES=<country_code_for_price> && heroku run rails twilio_price:fetch_new && heroku config:unset TWILIO_PRICE_COUNTRIES
```
