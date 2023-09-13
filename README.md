# RS2_seminarski

Korisnicki podaci za pristup aplikaciji

**Desktop verzija**

username - desktop
password - test

username - korisnik1
password - sifra1

username - korisnik2
password - sifra2

**Mobile verzija**

username - mobile
password - test

username - korisnik3
password - sifra3

username - korisnik4
password - sifra4

**Napomena za Stripe**

Postoje dva nacina konfiguracije,

-kroz environment 'flutter run --dart-define=stripePublishableKey=abcd' (opcija dostupna samo ako se koristi ova komanda pri pokretanju)

-kroz samu mobilnu aplikaciju je omoguceno unosenje Publishable Key-a (opcija uvijek dostupna, za unosenje ili za promjenu vec unesenog key-a kroz environment)


**Napomena za RabbitMQ**

Za slanje mail-ova se koristi Ethereal fake smtp servis (https://ethereal.email/) 

Zbog lakseg testiranja jedna adresa se koristi za slanje i primanje mail poruka 

Adresa: murl87@ethereal.email

Sifra: jCf9JwZUVATxEkvv1F 

Ovo se moze promijeniti i dodatno konfigurisati kroz docker-compose.yml fajl (za potrebe testiranja moguce je promijeniti adrese ili u slucaju isteka trajanja adrese moguce je generisati novu) 