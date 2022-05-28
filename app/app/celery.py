import os

from celery import Celery


ENVIRONMNENT = os.environ.get('ENVIRONMNENT')


if ENVIRONMNENT == 'DEV':
    import dotenv
    dotenv.read_dotenv('../envs/dev.env', override=True)
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings_dev')
else:
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')

app = Celery('app')

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()
