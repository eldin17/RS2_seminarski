// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Services.ArtikalStateMachine.RabbitMQType;
using eKucniLjubimci.Services.NarudzbaStateMachine.RabbitMQType;
using eKucniLjubimci.Services.ZivotinjaStateMachine.RabbitMQType;

Console.WriteLine("Seminarski rad eKucniLjubimci, RabbitMQ demonstracija");


Console.WriteLine("\n(Proizvoljna vrijednost)\nUnesite subscription ID: ");
var subscriptionId = Console.ReadLine();

//using (var bus = RabbitHutch.CreateBus("host=localhost"))
using (var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq"))
{
    bus.PubSub.Subscribe<rmqArtikal>(subscriptionId, HandleArtikalMessage);
    bus.PubSub.Subscribe<rmqZivotinja>(subscriptionId, HandleZivotinjaMessage);
    bus.PubSub.Subscribe<rmqNarudzba>(subscriptionId, HandleNarudzbaMessage);
    Console.WriteLine("Čekanje poruka. Pritisnite <return> za izlaz:");
    Console.ReadLine();
}

void HandleArtikalMessage(rmqArtikal entity)
{
    if (entity.Funkcija == "Add")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodan novi artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if(entity.Funkcija == "Activate")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je aktiviran artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Delete")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je izbrisan artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Update")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je azuriran artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "AddSlike")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo su dodane slike za artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Dostupnost")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je promijenjena dostupnost za artikal \n-Id: {entity?.ArtikalId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena} \n-Dostupnost: {entity?.Dostupnost}");
    }
}

void HandleZivotinjaMessage(rmqZivotinja entity)
{
    if (entity.Funkcija == "Add")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodana nova zivotinja \n-Id: {entity?.ZivotinjaId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Activate")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je aktivirana zivotinja \n-Id: {entity?.ZivotinjaId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Update")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je azurirana zivotinja \n-Id: {entity?.ZivotinjaId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "Delete")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je izbrisana zivotinja \n-Id: {entity?.ZivotinjaId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
    else if (entity.Funkcija == "AddSlike")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo su dodane slike za zivotinju \n-Id: {entity?.ZivotinjaId} \n-Naziv: {entity?.Naziv} \n-Cijena: {entity?.Cijena}");
    }
}

void HandleNarudzbaMessage(rmqNarudzba entity)
{
    if (entity.Funkcija == "Add")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodana nova narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "Activate")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodana nova narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "AddArtikal")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodat artikal na narudzbu \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "RemoveArtikal")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je uklonjen artikal sa narudzbe \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "AddZivotinja")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je dodana zivotinja na narudzbu \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "RemoveZivotinja")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je uklonjena zivotinja sa narudzbe \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "Update")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je azurirana narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "Activate")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je aktivirana narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "Delete")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je izbrisana narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "Cancel")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je otkazana narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }
    else if (entity.Funkcija == "StripePayment")
    {
        Console.WriteLine($"\nPoruka funkcije {entity.Funkcija} \nUpravo je placena narudzba \n-Id: {entity?.NarudzbaId} \n-Id kupca: {entity?.KupacId} \n-Datum: {entity?.DatumNarudzbe}");
    }   
}

