# Webradio

shows my favorite webstations

all stations should be listed https://www.radio-browser.info/

example  Radio Caroline https://www.radio-browser.info/history/9606ceae-0601-11e8-ae97-52543be04c81


## local development

```
bin/setup
bin/dev

```

## update radios streaming urls

bin/rails update_stations_from_browser_info


## Kamal

https://kamal-deploy.org/docs/commands/view-all-commands/

### logs

kamal app logs -f

### infos

kamal audit # Show the latest commands to have been run on each server.

kamal details -q # Shows details of all your containers
