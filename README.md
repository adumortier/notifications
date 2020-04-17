### Notification Microservice

This notification microservice is used along with the Gard(in)That app. It allows the app to interact with the Google Calendar API and send notifications to users when they have added plants to their virtual garden.

Gard(in)That app repository:

https://github.com/adumortier/gardenthat

Gard(in)That on Heroku

https://gardenthat.herokuapp.com/

### Notification Microservice Access Points 

Retrieve the events from the GardenThatApp calendar:
```sh
GET https://notificationmicroservice.herokuapp.com/events/info?token=<your_google_token_here>&refresh_token=<your_google_refresh_token_here>&calendar_name=GardenThatApp
```
Create a new calendar:
```sh
POST https://notificationmicroservice.herokuapp.com/calendar/new?token=<your_google_token_here>&refresh_token=<your_google_refresh_token_here>&calendar_name=<calendar_name_here>
```

Create a new event (date format yyyy-mm-dd):
```sh
POST https://notificationmicroservice.herokuapp.com/event/new?token=<your_google_token_here>&refresh_token=<your_google_refresh_token_here>&name=<event_name_here>&description=<event_description_here>&date=<date_here>

```
Delete an event:
```
DELETE https://notificationmicroservice.herokuapp.com/event/info?token=<your_google_token_here>&refresh_token=<your_google_refresh_token_here>&calendar_id=<calendar_id_here>&event_id=<event_id_here>
```
