using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.ArtikalStateMachine.RabbitMQType;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.NarudzbaStateMachine.RabbitMQType;
using eKucniLjubimci.Services.ZivotinjaStateMachine.RabbitMQType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services
{
    public class AutoMapperProfile:Profile
    {
        public AutoMapperProfile()
        {
            CreateMap<Osoba, DtoOsoba>().ReverseMap();
            CreateMap<Osoba, AddOsoba>().ReverseMap();
            CreateMap<Osoba, UpdateOsoba>().ReverseMap();

            CreateMap<KorisnickiNalog, DtoKorisnickiNalog>().ReverseMap();
            CreateMap<KorisnickiNalog, AddKorisnickiNalog>().ReverseMap();

            CreateMap<Uloga, DtoUloga>().ReverseMap();

            CreateMap<Rasa, DtoRasa>().ReverseMap();

            CreateMap<Slika, DtoSlika>().ReverseMap();

            CreateMap<NarudzbaArtikal, DtoNarudzbaArtikal>().ReverseMap();


            CreateMap<Kupac, DtoKupac>().ReverseMap();
            CreateMap<Kupac, AddKupac>().ReverseMap();
            CreateMap<Kupac, UpdateKupac>().ReverseMap();

            CreateMap<Lokacija, DtoLokacija>().ReverseMap();
            CreateMap<Lokacija, AddLokacija>().ReverseMap();
            CreateMap<Lokacija, UpdateLokacija>().ReverseMap();

            CreateMap<Narudzba, DtoNarudzba>().ReverseMap();
            CreateMap<Narudzba, AddNarudzba>().ReverseMap();
            CreateMap<Narudzba, UpdateNarudzba>().ReverseMap();
            CreateMap<Narudzba, rmqNarudzba>().ReverseMap();


            CreateMap<Artikal, DtoArtikal>().ReverseMap();
            CreateMap<Artikal, AddArtikal>().ReverseMap();
            CreateMap<Artikal, UpdateArtikal>().ReverseMap();
            CreateMap<Artikal, rmqArtikal>().ReverseMap();


            CreateMap<Kategorija, DtoKategorija>().ReverseMap();
            CreateMap<Kategorija, AddKategorija>().ReverseMap();
            CreateMap<Kategorija, UpdateKategorija>().ReverseMap();

            CreateMap<Novost, DtoNovost>().ReverseMap();
            CreateMap<Novost, AddNovost>().ReverseMap();
            CreateMap<Novost, UpdateNovost>().ReverseMap();

            CreateMap<Prodavac, DtoProdavac>().ReverseMap();
            CreateMap<Prodavac, AddProdavac>().ReverseMap();
            CreateMap<Prodavac, UpdateProdavac>().ReverseMap();

            CreateMap<Vrsta, DtoVrsta>().ReverseMap();
            CreateMap<Vrsta, AddVrsta>().ReverseMap();
            CreateMap<Vrsta, UpdateVrsta>().ReverseMap();

            CreateMap<Zivotinja, DtoZivotinja>().ReverseMap();
            CreateMap<Zivotinja, AddZivotinja>().ReverseMap();
            CreateMap<Zivotinja, UpdateZivotinja>().ReverseMap();
            CreateMap<Zivotinja, rmqZivotinja>().ReverseMap();

        }
    }
}
