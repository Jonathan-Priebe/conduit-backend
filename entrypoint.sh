#!/bin/bash

# If CI_MODE is enabled, run Gunicorn config check and exit
if [ "$CI_MODE" = "true" ]; then
  echo "CI mode detected: running Gunicorn config check only..."
  gunicorn conduit.wsgi:application --check-config --log-level debug
  exit $?
fi

#Applied Django migrations to sync database schema with models.
python manage.py migrate

#Created Django superuser for admin interface access.
#python manage.py createsuperuser

# Check if a superuser exists; if not, one will be created.
echo "Checking for existing superuser..."
if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
  DJANGO_SETTINGS_MODULE=conduit.settings python -c "
import django;
django.setup();
from django.contrib.auth import get_user_model;
User = get_user_model();
username = '$DJANGO_SUPERUSER_USERNAME';
email = '$DJANGO_SUPERUSER_EMAIL';
password = '$DJANGO_SUPERUSER_PASSWORD';
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password);
    print('Superuser created.');
else:
    print('Superuser already exists.');
"
fi

#Start and runs server at port 3000
#python manage.py runserver 0.0.0.0:3000 ##For debug
gunicorn conduit.wsgi:application --bind 0.0.0.0:3000