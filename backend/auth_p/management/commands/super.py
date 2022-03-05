from django.core.management import BaseCommand

from auth_p.models import User


class Command(BaseCommand):
    def handle(self, *args, **options):
        username = input("Username: ")
        acc = User.objects.get(username=username)
        self.stdout.write("\nPlease Make sure this your user: ")
        self.stdout.write(f"\nusername: {acc.username} email: {acc.email}")
        x = input("Y/N").lower()
        if x == 'y':
            acc.is_superuser = True
            acc.is_staff = True
            acc.save()
            self.stdout.write("done")
        else:
            self.stdout.write("Skipped")
