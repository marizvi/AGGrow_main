import os
import threading

from django.conf import settings
from rest_framework.response import Response as DRFResponse
from rest_framework.serializers import Serializer, ListSerializer
from sendgrid import Mail, SendGridAPIClient


def run_in_thread(fn):
    def run(*k, **kw):
        t = threading.Thread(target=fn, args=k, kwargs=kw)
        t.start()
        return t

    return run


def send_registration_verification_mail(user, verification_code, threaded=False):
    """
    Send an email to the user with a link to verify_view their email address.
    """

    def _send_registration_verification_mail(_user, _verification_code: str):
        from_email = settings.DEFAULT_FROM_EMAIL

        message = Mail(
            from_email=from_email,
            to_emails=[_user.email])
        message.dynamic_template_data = {
            'username': _user.username,
            'domain': settings.SITE_URL,
            'verification_hash': _verification_code,
        }

        message.template_id = os.environ.get('REGISTRATION_TEMPLATE_ID')

        try:
            sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
            response = sg.send(message)
            print(response.status_code)
            print(response.body)
        except Exception as e:
            print(e.message)

    if threaded:
        run_in_thread(_send_registration_verification_mail)(user, verification_code)
    else:
        _send_registration_verification_mail(user, verification_code)


class Response(DRFResponse):
    def __init__(self, data=None, check_valid=True, *args, **kwargs):
        if isinstance(data, Serializer) or isinstance(data, ListSerializer):
            if check_valid:
                if data.is_valid():
                    data = data.validated_data
                else:
                    raise ValueError(data.errors)
            else:
                data = data.data
        super().__init__(data=data, *args, **kwargs)
